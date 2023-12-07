ENT.Type = "anim"
ENT.PrintName = "Combine Appartaments Lock"
ENT.Category = "HL2 RP"
ENT.Author = "Geferon"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.PLUGIN = PLUGIN

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Locked")
	self:NetworkVar("Bool", 1, "Erroring")
	self:NetworkVar("Bool", 2, "Cracked")
	self:NetworkVar("Bool", 3, "Detonating")
	-- self:NetworkVar("Float", 0, "Flash")
	-- self:NetworkVar("Float", 1, "ActiveSmokeCharge")
	-- self:NetworkVar("Float", 2, "DisabledUntil")
	self:NetworkVar("String", 0, "Block")
end

function ENT:SpawnFunction(client, trace)
	local door = trace.Entity

	if (!IsValid(door) or !door:IsDoor() or IsValid(door.lock)) then
		return ix.util.NotifyLocalized("apartsContrlLockCant", client)
	end

	local position, angles = self:GetLockPos(client, door)

	local entity = ents.Create("ix_term_locks")
	entity:SetPos(trace.HitPos)
	entity:Spawn()
	entity:Activate()
	entity:SetDoor(door, position, angles)

	local BlocksName = ix.config.Get("apartsContrlBlock")

	local blocks = {}
	for k, v in pairs(ents.GetAll()) do
		if v:IsDoor() then
			local name = self.PLUGIN:GetDoorName(v)

			if not name then continue end

			local BlockName = string.match(name, BlocksName)
			if (BlockName and BlockName != "") then
				if not table.HasValue(blocks, BlockName) then
					table.insert(blocks, BlockName)
				end
			end
		end
	end
	net.Start("ix_civil_terminal_lock_request")
		net.WriteTable(blocks)
		net.WriteFloat(entity:EntIndex())
	net.Send(client)

	return entity
end

function ENT:GetAppartment()
	local door = self.door
	if (not IsValid(self.door)) or (not door:IsDoor()) then return end

	local doorName = self.PLUGIN:GetDoorName(door)
	local appsConfig = ix.config.Get("apartsContrlApps")
	local doorId = string.match(doorName, appsConfig)

	return doorId or false
end
