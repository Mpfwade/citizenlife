PLUGIN.name = "Advanced Apartments Controller"
PLUGIN.author = "Geferon"
PLUGIN.description = "Do you want to have an advanced apartments system for the combine? Well, now you can have one!"

function PLUGIN:GetDoorName(door)
	if not IsValid(door) then return end
	if not door:IsDoor() then return end

	return door:GetNetVar("title", door:GetNetVar("name"))
end

ix.config.Add("apartsContrlBlock", "Block ([%w%s]+)", "This is the format of the name for an Apartments block. It has to follow the Lua's pattern language", nil, {
	category = "apartsContrlCat"
})
ix.config.Add("apartsContrlApps", "Apartment #([%w%s]+)", "This is the format of the name of an apartment. It has to follow the Lua's pattern language", nil, {
	category = "apartsContrlCat"
})


function PLUGIN:SaveData()
	local saved = {}
	saved.locks = {}
	saved.terminals = {}

	for k, v in pairs(ents.GetAll()) do
		local class = v:GetClass()

		if class == "ix_civil_terminal" then
			table.insert(saved.terminals, {
				position = v:GetPos(),
				angles = v:GetAngles(),
				block = v:GetBlockStr(),
				entrance = v:GetEntrance()
			})
		elseif class == "ix_term_locks" then
			table.insert(saved.locks, {
				locked = v:GetLocked(),
				angles = v.door:WorldToLocalAngles(v:GetAngles()),
				position = v.door:WorldToLocal(v:GetPos()),
				MapID = v.door:MapCreationID(),
				block = v:GetBlock()
			})
		end
	end

	self:SetData(saved)
end

function PLUGIN:LoadData()
	local saved = self:GetData() or {}

	for k, v in pairs(saved.terminals or {}) do
		local entity = ents.Create("ix_civil_terminal")
		entity:SetAngles(v.angles)
		entity:SetPos(v.position)
		entity:Spawn()
		entity:SetBlock(v.block)
		entity:SetEntrance(v.entrance)

		local physicsObject = entity:GetPhysicsObject()

		if ( IsValid(physicsObject) ) then
			physicsObject:EnableMotion(false)
		end
	end

	for k, v in pairs(saved.locks or {}) do
		local door = ents.GetMapCreatedEntity(v.MapID)
		if (IsValid(door) and door:IsDoor()) then
			local entity = ents.Create("ix_term_locks")
			entity:SetPos(door:GetPos())
			entity:Spawn()
			entity:SetDoor(door, door:LocalToWorld(v.position), door:LocalToWorldAngles(v.angles))
			entity:SetLocked(v.locked)

			entity:Toggle(v.locked)
			entity:SetupBlock(v.block)
		end
	end
end
