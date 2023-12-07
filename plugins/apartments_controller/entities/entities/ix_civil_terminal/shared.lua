DEFINE_BASECLASS("base_gmodentity")

ENT.Type = "anim"
ENT.Author = "Geferon"
ENT.PrintName = "Apartment Terminal"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisabled = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.PLUGIN = PLUGIN

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

function ENT:SpawnFunction(ply, trace, ClassName)
	if not trace.Hit then return end
	if not ply:IsAdmin() then return end

	local angles = (ply:GetPos() - trace.HitPos):Angle()
	angles.p = 0
	angles.r = 0
	--angles:RotateAroundAxis(angles:Up(), 90)

	local entity = ents.Create("ix_civil_terminal")
	entity:SetPos(trace.HitPos)
	entity:SetAngles(angles:SnapTo("y", 45))
	entity:Spawn()
	entity:Activate()

	local doors, blocks = entity:GetBlockDoors()
	net.Start("ix_civil_terminal_request")
		net.WriteTable(blocks)
		net.WriteFloat(entity:EntIndex())
	net.Send(ply)

	return entity
end

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Enabled")
	self:NetworkVar("Bool", 1, "Entrance")
	--self:NetworkVar("Int", 0, "Color")
	self:NetworkVar("Int", 0, "State")
	self:NetworkVar("Float", 0, "OpenTime")
	self:NetworkVar("String", 0, "BlockStr")
	self:NetworkVar("String", 1, "Text")
end

function ENT:GetDisabled()
	return not self:GetEnabled()
end

function ENT:IsEntrance()
	return self:GetEntrance()
end

function ENT:GetBlockDoors()
	if not self:GetBlockStr() then return false end

	local BlocksName = ix.config.Get("apartsContrlBlock")

	local doors = {}
	local blocks = {}
	for k, v in pairs(ents.GetAll()) do
		if v:IsDoor() then
			local name = self.PLUGIN:GetDoorName(v)

			if not name then continue end

			local BlockName = string.match(name, BlocksName)
			if (BlockName and BlockName != "") then
				if string.lower(BlockName) == string.lower(self:GetBlockStr()) then
					table.insert(doors, v)
				end
				if not table.HasValue(blocks, BlockName) then
					table.insert(blocks, BlockName)
				end
			end
		end
	end

	return doors, blocks
end

function ENT:GetBlockByApartment(apart)
	if (not apart) then return end
	apart = isnumber(apart) and apart or tonumber(apart)
	if not apart then return end

	local block

	-- print(apart)
	-- print("-----")
	for k, v in pairs(ents.FindByClass("ix_term_locks")) do
		local appid = tonumber(v:GetAppartment())
		-- print(appid)
		-- print(v:GetBlock())
		if appid and appid == apart then
			block = v:GetBlock()
			break
		end
	end

	return block or false
end
