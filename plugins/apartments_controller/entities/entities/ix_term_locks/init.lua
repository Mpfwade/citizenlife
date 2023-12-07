include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

local PLUGIN = PLUGIN

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_lock01.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetUseType(SIMPLE_USE)
	self.onDoorRestored = function(self, door)
		self:Toggle(false)
	end
end

function ENT:OnRemove()
	for k, v in pairs(self.doors) do
		if IsValid(v) then
			v:Fire("Unlock", "", 0)
			v.lock = nil
		end
	end
end

function ENT:CanOpenDoor(door, ply)
	if not door:IsDoor() then return end

	local inv = ply:GetChar():GetInv()
	--[[
	local items = Clockwork.inventory:GetItemsByID(inv, "idcard") or {}
	table.Merge(items, Clockwork.inventory:GetItemsByID(inv, "cid_card") or {})
	table.Merge(items, Clockwork.inventory:GetItemsByID(inv, "cwu_card") or {})
	--]]
	local items = inv:GetItemsByUniqueID("cid") or {}

	local appsConfig = ix.config.Get("apartsContrlApps")
	local doorName = PLUGIN:GetDoorName(door)
	local doorId = string.match(doorName, appsConfig)
	if !doorId then return false end

	for k, v in pairs(items) do
		if not v:GetData("employment") then continue end

		if v:GetData("employment") == doorId then
			return true
		end
	end
	return false
end

function ENT:Use(activator)
	if (self:GetErroring()) then
		return
	end
	if self:GetCracked() then
		return
	end

	if ((activator.ixNextLockUse or 0) < CurTime()) then
		activator.ixNextLockUse = CurTime() + 1
	else
		return
	end

--	if (CurTime() <= self:GetFlash()) then
--		return
--	end
-- 71 and player:Team() != FACTION_ADMIN)
	if (!(activator:IsCombine()) and !self:CanOpenDoor(self.door, activator)) then
		self:Error()

		return
	end

	if (hook.Run("PlayerCanUseLock", activator) != false) then
		self:Toggle()
	end
end

function ENT:Error()
	self:EmitSound("buttons/combine_button_locked.wav")
	self:SetErroring(true)

	timer.Create("ix_CombineLockErroring" .. self:EntIndex(), 1, 2, function()
		if (IsValid(self)) then
			self:SetErroring(false)
		end
	end)
end

function ENT:Toggle(override)
	if (override != nil) then
		self:SetLocked(override)
	elseif ((self.nextToggle or 0) < CurTime()) then
		self.nextToggle = CurTime() + 1
		self:SetLocked(!self:GetLocked())
	else
		return
	end

	if (!self:GetLocked()) then
		self:EmitSound("buttons/combine_button7.wav")
	else
		self:EmitSound("buttons/combine_button2.wav")
	end

	for k, v in pairs(self.doors) do
		if (IsValid(v)) then
			if (self:GetLocked()) then
				v:Fire("Lock", "", 0)
				v:Fire("Close", "", 0)
			else
				v:Fire("Unlock", "", 0)
			end
		end
	end
end

function ENT:GetLockPos(client, door)
	local index, index2 = door:LookupBone("handle")
	local normal = client:GetEyeTrace().HitNormal:Angle()
	local position = client:GetEyeTrace().HitPos

	if (index and index >= 1) then
		position = door:GetBonePosition(index)
	end

	position = position + normal:Forward() * 2.5 + normal:Up() * 10 + normal:Right() * 2

	normal:RotateAroundAxis(normal:Up(), 90)
	normal:RotateAroundAxis(normal:Forward(), 180)
	normal:RotateAroundAxis(normal:Right(), 180)

	return position, normal
end

function ENT:SetDoor(door, position, angles)
	if (!IsValid(door)) then
		return
	end

	self.door = door
	self.doors = {door}
	if IsValid(door:GetDoorPartner()) then
		table.insert(self.doors, door:GetDoorPartner())
	end
	door.lock = self

	self:SetPos(position)
	self:SetAngles(angles)
	self:SetParent(door)

	self:Toggle(true)
end

function ENT:SetupBlock(block)
	self:SetBlock(block)
	self:Toggle(true)
end

function ENT:Detonate(client)
		self:SetDetonating(true)
		self.detonateStartTime = CurTime()
		self.detonateEndTime = self.detonateStartTime + 10
		self.explodeDir = client:GetAimVector() * 500
	end

function ENT:Ping()
	self:SetErroring(true)
	self:EmitSound("npc/turret_floor/ping.wav")

	timer.Create("ixPing"..self:EntIndex(), 0.1, 1, function()
		if (IsValid(self)) then
			self:SetErroring(false)
		end
	end)
end

function ENT:Think()
	if (not self:GetDetonating()) then return end
	local curTime = CurTime()

	if (self.detonateEndTime <= curTime) then
		self:Explode()
		return
	end

	if ((self.nextPing or 0) >= curTime) then
		return
	end

	local fraction = 1 - math.Clamp(math.TimeFraction(
		self.detonateStartTime,
		self.detonateEndTime,
		curTime
	), 0, 1)
	self.nextPing = curTime + fraction
	self:Ping()
end

function ENT:Explode()
	local effect = EffectData()
		effect:SetOrigin(self:GetPos())
	util.Effect("Explosion", effect)

	local entity = self:GetParent()
	if (not IsValid(entity)) then return end

	entity:EmitSound("physics/wood/wood_crate_break"..math.random(1, 5)..".wav", 150)
	local direction = (self.explodeDir or VectorRand()):GetNormalized()
	direction.z = 0
	entity:BlastDoor(direction * 400)

	self:Remove()
end

-- function ENT:SetFlashDuration(duration)
-- 	self:EmitSound("buttons/combine_button_locked.wav")
-- 	self:SetFlash(CurTime() + duration)
-- end

-- function ENT:ActivateSmokeCharge(force)
-- 	local curTime = CurTime()

-- 	if (self:GetActiveSmokeCharge() < curTime) then
-- 		self:SetActiveSmokeCharge(curTime + 12)
-- 		self:SetDisabledUntil(curTime + 40)

-- 		Clockwork.kernel:CreateTimer("smoke_charge_" .. self:EntIndex(), 12, 1, function()
-- 			if (IsValid(self)) then

-- 				for k, v in ipairs(self.doors) do
-- 					if (IsValid(v) and string.lower( v:GetClass() ) == "prop_door_rotating") then
-- 						Schema:BustDownDoor(nil, v, force)

-- 						local effectData = EffectData()

-- 						effectData:SetOrigin( self:GetPos() )
-- 						effectData:SetScale(0.75)

-- 						util.Effect("cw_effect_smoke", effectData, true, true)
-- 					end
-- 				end
-- 			end
-- 		end)
-- 	end
-- end


util.AddNetworkString("ix_civil_terminal_lock_request")

net.Receive("ix_civil_terminal_lock_request", function(len, ply)
	if not ply:IsAdmin() then return end

	local ent = net.ReadFloat()
	local block = net.ReadString()
	ent = Entity(ent)
	if ent:GetClass() != "ix_term_locks" then return end

	ent:SetupBlock(block)
end)
