include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

util.AddNetworkString("ix_civil_terminal_request")

resource.AddFile("materials/geferon/blur.vmt")

local OpenTime = 5


-- ENUMS
local COLOR_RED = 1
local COLOR_ORANGE = 2
local COLOR_BLUE = 3
local COLOR_GREEN = 4

local colors = {
	[COLOR_RED] = Color(255, 50, 50),
	[COLOR_ORANGE] = Color(255, 80, 20),
	[COLOR_BLUE] = Color(50, 80, 230),
	[COLOR_GREEN] = Color(50, 240, 50)
}

local STATE_IDLE = 1
local STATE_CHECKING = 2
local STATE_ERROR = 3
local STATE_SUCCESFUL = 4
local STATE_OPENED = 5
local STATE_CLOSING = 6
local STATE_DISABLED = 7

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_interface002.mdl")

	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetEnabled(false)
	self:SetEntrance(true)
	--self:SetColor(COLOR_GREEN)
	self:SetState(STATE_ERROR)

	local physicsObject = self:GetPhysicsObject()
	physicsObject:SetMass( 101 )

	self.timeStep = 8

	if ( IsValid(physicsObject) ) then
		physicsObject:Sleep()
		physicsObject:EnableMotion(false)
	end
end

function ENT:SetBlock(block)
	self:SetBlockStr(block)
	self:SetEnabled(true)
	self:SetNormalState()
end

net.Receive("ix_civil_terminal_request", function(len, ply)
	if not ply:IsAdmin() then return end

	local ent = net.ReadFloat()
	local block = net.ReadString()
	local entrance = net.ReadBool()
	ent = Entity(ent)
	if ent:GetClass() != "ix_civil_terminal" then return end

	ent:SetBlock(block)
	ent:SetEntrance(entrance)
end)

function ENT:EmitRandomSound()
	local randomSounds = {
		"ambient/machines/combine_terminal_idle4.wav"
	}

	self:EmitSound( randomSounds[ math.random(1, #randomSounds) ] )
end

function ENT:PhysicsUpdate(physicsObject)
	if not self:IsPlayerHolding() and not self:IsConstrained() then
		physicsObject:SetVelocity( Vector(0, 0, 0) )
		physicsObject:Sleep()
	end
end

function ENT:CanTool(player, trace, tool)
	return false
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:SetNormalState()
	self:SetState(STATE_IDLE)
	self:SetText("apartsContrlTermWaitingUser")
	self:SincronizeState(true)
end

function ENT:SincronizeState(txt)
	if not self:GetBlockStr() then return end
	local selfblock = self:GetBlockStr()

	for k, v in pairs(ents.FindByClass("ix_civil_terminal")) do
		if v == self then continue end
		local block = v:GetBlockStr()
		if block and block == selfblock then
			v:SetState(self:GetState())
			if txt then
				if isstring(txt) then
					v:SetText(txt)
				else
					v:SetText(self:GetText())
				end
			end
			v:SetEnabled(self:GetEnabled())
		end
	end
end

function ENT:Error(text, time)
	self:EmitSound("buttons/combine_button_locked.wav")
	self:SetState(STATE_ERROR)
	self:SetText(text)
	self:SincronizeState("apartsContrlTermSyncErr")

	timer.Simple(time or 5, function()
		if not IsValid(self) then return end

		self:SetNormalState()
		self:SincronizeState()
	end)
end

function ENT:ToggleBlock(open, ply)
	if open then
		self:SetState(STATE_OPENED)
		self:SetText("apartsContrlTermOpenDoors")
		self:SincronizeState(true)

		self:SetOpenTime(CurTime() + OpenTime)
	else
		self:SetState(STATE_CLOSING)
		self:SetText("apartsContrlTermCloseDoors")
		self:SincronizeState(true)
	end

	local doors = self:GetBlockDoors()
	if (not doors) or table.Count(doors) < 1 then return end

	local locks = {}
	for k, v in pairs(self:GetBlockDoors()) do
		if v.lock and not table.HasValue(locks, v) then
			v.lock:Toggle(not open)
			if open then
				if IsValid(ply) then
					v:Fire("unlock")
					timer.Simple(0.1, function()
						if IsValid(v) and IsValid(ply) then
							v:Use(ply, ply, USE_ON, 1)
						end
					end)
				else
					v:Fire("open")
				end
			end
			table.insert(locks, v)
		end
	end
end

function ENT:CheckingState()
	self:EmitSound("ambient/machines/combine_terminal_idle2.wav")
	self:SetState(STATE_CHECKING)
	self:SetText("apartsContrlTermChecking")
	self:SincronizeState("apartsContrlTermWorking")
end

function ENT:SuccesfulState()
	self:SetState(STATE_SUCCESFUL)
	self:EmitSound("buttons/button14.wav", 100, 50)
	self:SincronizeState()
end

function ENT:Use(activator, caller)
	if not activator:IsPlayer() then return end
	if self:GetState() != STATE_IDLE and self:GetState() != STATE_DISABLED then return end

	if activator:IsCombine() then
		self:SetEnabled(not self:GetEnabled())
		self:EmitSound("buttons/combine_button2.wav")

		if self:GetEnabled() then
			self:SetNormalState()
			return
		end
		self:SetState(STATE_DISABLED)
		self:SetText("apartsContrlTermDesact")
		self:SincronizeState(true)
		return
	end

	if self:GetDisabled() then return end

	local curTime = CurTime()

	if not self:IsEntrance() then
		self:ToggleBlock(true, activator)
		timer.Simple(OpenTime, function()
			if not IsValid(self) then return end

			self:ToggleBlock(false, activator)

			timer.Simple(2, function()
				if not IsValid(self) then return end

				self:SetNormalState()
			end)
		end)
		return
	end

	self:CheckingState()
	timer.Simple(1.5, function()
		if not IsValid(self) then return end

		local inv = activator:GetChar():GetInv()
		local items = inv:GetItemsByUniqueID("apartment_card") or {}

		if table.Count(items) < 1 then
			self:Error("apartsContrlTermErrNoAppsCard")
			return
		end

		if table.Count(items) > 1 then
			local allowed = false
			local blocks = {}
			for k, v in pairs(items) do
				local Apart = v:GetData("apartment")
				if (not Apart) then
					continue
				end
				local Block = self:GetBlockByApartment(Apart)
				if not Block then
					continue
				end

				if Block != self:GetBlockStr() then
					table.insert(blocks, Block)
					continue
				end

				allowed = true
			end

			if not allowed then
				local errorTxt = "apartsContrlTermErrInvalidBlock"
				if table.Count(blocks) == 1 then
					errorTxt = "apartsContrlTermErrInvalidBlockLocated;" .. blocks[1]
				end

				self:Error(errorTxt, 7)

				return
			end
		else
			local _, card = next(items)
			local Apart = card:GetData("apartment")

			if (not Apart) or Apart == "N/A" then
				self:Error("apartsContrlTermErrNoAppsAsign")
				return
			end

			local Block = self:GetBlockByApartment(Apart)
			if not Block then
				self:Error("apartsContrlTermErrNoAppsInval")
				return
			end

			if Block != self:GetBlockStr() then
				local errorTxt = "apartsContrlTermErrInvalidBlockLocated;" .. Block

				self:Error(errorTxt, 7)
				return
			end
		end

		timer.Simple(1, function()
			if not IsValid(self) then return end

			self:ToggleBlock(true, activator)

			timer.Simple(OpenTime, function()
				if not IsValid(self) then return end

				self:ToggleBlock(false, activator)

				timer.Simple(2, function()
					if not IsValid(self) then return end

					self:SetNormalState()
				end)
			end)
		end)
	end)
end
