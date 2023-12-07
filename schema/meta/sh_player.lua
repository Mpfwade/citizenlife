--[[---------------------------------------------------------------------------
	Player Meta Functions
---------------------------------------------------------------------------]]
--
local PLAYER = FindMetaTable("Player")

function PLAYER:IsCitizen()
    return self:Team() == FACTION_CITIZEN
end

function PLAYER:IsRebel()
    return self:Team() == FACTION_CITIZEN and self.ixRebelState == true
end

function PLAYER:IsCWU()
    return self:Team() == FACTION_CWU
end

function PLAYER:IsCombine()
    return self:Team() == FACTION_CCA or self:Team() == FACTION_OTA or self:Team() == FACTION_DISPATCH
end

function PLAYER:IsCombineCommand()
    return self:IsCombine() and ((self.ixOTARank == 3) or (self.ixCCARank == 4) or (self.ixOTADivision == 6))
end

function PLAYER:IsCombineLeader()
    return self:IsCombine() and (self.ixCCARank == 4 or self.ixOTARank == 3)
end

function PLAYER:IsCA()
    return self:Team() == FACTION_CA
end

function PLAYER:IsVortigaunt()
    return self:Team() == FACTION_VORTIGAUNT
end

function PLAYER:IsDispatch()
    return self:Team() == FACTION_DISPATCH
end

function PLAYER:IsDonator()
    return self:GetUserGroup() == "donator"
end

function PLAYER:IsGamemaster()
    return self:GetUserGroup() == "gamemaster"
end

function PLAYER:IsMod()
    return self:GetUserGroup() == "mod"
end

function PLAYER:IsMale()
	local model = self:GetModel():lower()

	return (model:find("male") or model:find("alyx") or model:find("mossman")) != nil or
		ix.anim.GetModelClass(model) == "citizen_male"
end


if SERVER then
    local PLAYER = FindMetaTable("Player")
    util.AddNetworkString("ixAddCombineDisplayMessage")

    function PLAYER:AddCombineDisplayMessage(text, color, sound)
        net.Start("ixAddCombineDisplayMessage")
        net.WriteString(tostring(text) or "Invalid Input..")
        net.WriteColor(color or color_white)
        net.WriteBool(tobool(sound) or false)
        net.Send(self)
    end

    util.AddNetworkString("ixPlaySound")

    function PLAYER:PlaySound(sound, pitch)
        net.Start("ixPlaySound")
        net.WriteString(tostring(sound))
        net.WriteUInt(tonumber(pitch) or 100, 7)
        net.Send(self)
    end

    util.AddNetworkString("ixCreateVGUI")

    function PLAYER:OpenVGUI(panel)
        if not isstring(panel) then
            ErrorNoHalt("Warning argument is required to be a string! Instead is " .. type(panel) .. "\n")

            return
        end

        net.Start("ixCreateVGUI")
        net.WriteString(panel)
        net.Send(self)
    end

    function PLAYER:NearEntity(entity, radius)
        for k, v in ipairs(ents.FindInSphere(self:GetPos(), radius or 96)) do
            if v:GetClass() == entity then return true end
        end

        return false
    end

    --[[
		-- Used the same as the above but you input a pure entity e.g. --
		local ply = Entity(1)
		local our_ent = Entity(123)
		if ( ply:NearEntityPure(our_ent) ) then
			DoStuff()
		end
	]]
    function PLAYER:NearEntityPure(entity, radius)
        for k, v in ipairs(ents.FindInSphere(self:GetPos(), radius or 96)) do
            if v == entity then return true end
        end

        return false
    end

    function PLAYER:NearPlayer(radius)
        for k, v in ipairs(ents.FindInSphere(self:GetPos(), radius or 96)) do
            if v:IsPlayer() and v:Alive() and v:IsValid() then return true end
        end

        return false
    end
else
    local PLAYER = FindMetaTable("Player")

    -- Could be slightly expensive so I'll try some optimization methods ~ scotnay
    function PLAYER:GetPlayerInArea()
        -- Area plugin not used method useless
        if not ix.area and not ix.area.stored then return end
        local oldArea = self.oldArea or nil

        -- If an area already exists it saves us having to loop over everything
        if oldArea then
            local areaData = ix.area.stored[oldArea]

            if not areaData then
                self.oldArea = nil

                return self.oldArea
            end

            local min, max = areaData.startPosition, areaData.endPosition
            -- Pos is at feet so we add the center so if the area is off the ground still registers
            local pos = self:GetPos() + self:OBBCenter()

            if pos:WithinAABox(max, min) then
                self.oldArea = self.oldArea

                return self.oldArea
            else
                self.oldArea = nil
                self.oldAreaTimer = nil
                self:GetPlayerInArea() -- Try again since no longer in area
            end
        else
            for i, v in pairs(ix.area.stored) do
                local min, max = v.startPosition, v.endPosition
                local pos = self:GetPos() + self:OBBCenter()

                if pos:WithinAABox(min, max) then
                    self.oldArea = i

                    return self.oldArea
                end
            end
        end

        return nil
    end
end


function PLAYER:ShouldSetRagdolled(bState)
    if not self:Alive() then return end

    if bState then
        if IsValid(self.ixRagdoll) then
            self.ixRagdoll:Remove()
        end

        local entity = self:CreateServerRagdoll()

        entity:CallOnRemove("fixer", function()
            if IsValid(self) then
                self:SetLocalVar("blur", nil)
                self:SetLocalVar("ragdoll", nil)

                if not entity.ixNoReset then
                    self:SetPos(entity:GetPos())
                end

                self:SetNoDraw(false)
                self:SetNotSolid(false)
                self:SetMoveType(MOVETYPE_WALK)
                self:SetLocalVelocity(IsValid(entity) and entity.ixLastVelocity or vector_origin)
            end

            if IsValid(self) and not entity.ixIgnoreDelete then
                if entity.ixWeapons then
                    for _, v in ipairs(entity.ixWeapons) do
                        if v.class then
                            local weapon = self:Give(v.class, true)

                            if v.item then
                                weapon.ixItem = v.item
                            end

                            self:SetAmmo(v.ammo, weapon:GetPrimaryAmmoType())
                            weapon:SetClip1(v.clip)
                        elseif v.item and v.invID == v.item.invID then
                            v.item:Equip(self, true, true)
                            self:SetAmmo(v.ammo, self.carryWeapons[v.item.weaponCategory]:GetPrimaryAmmoType())
                        end
                    end
                end

                if entity.ixActiveWeapon then
                    if self:HasWeapon(entity.ixActiveWeapon) then
                        self:SetActiveWeapon(self:GetWeapon(entity.ixActiveWeapon))
                    else
                        local weapons = self:GetWeapons()

                        if #weapons > 0 then
                            self:SetActiveWeapon(weapons[1])
                        end
                    end
                end

                if self:IsStuck() then
                    entity:DropToFloor()
                    self:SetPos(entity:GetPos() + Vector(0, 0, 16))

                    local positions = ix.util.FindEmptySpace(self, {entity, self})

                    for _, v in ipairs(positions) do
                        self:SetPos(v)
                        if not self:IsStuck() then return end
                    end
                end
            end
        end)

        self:SetLocalVar("blur", 25)
        self.ixRagdoll = entity
        entity.ixWeapons = {}
        entity.ixPlayer = self

        if IsValid(self:GetActiveWeapon()) then
            entity.ixActiveWeapon = self:GetActiveWeapon():GetClass()
        end

        for _, v in ipairs(self:GetWeapons()) do
            if v.ixItem and v.ixItem.Equip and v.ixItem.Unequip then
                entity.ixWeapons[#entity.ixWeapons + 1] = {
                    item = v.ixItem,
                    invID = v.ixItem.invID,
                    ammo = self:GetAmmoCount(v:GetPrimaryAmmoType())
                }

                v.ixItem:Unequip(self, false)
            else
                local clip = v:Clip1()
                local reserve = self:GetAmmoCount(v:GetPrimaryAmmoType())

                entity.ixWeapons[#entity.ixWeapons + 1] = {
                    class = v:GetClass(),
                    item = v.ixItem,
                    clip = clip,
                    ammo = reserve
                }
            end
        end

        self:GodDisable()
        self:StripWeapons()
        self:SetMoveType(MOVETYPE_OBSERVER)
        self:SetNoDraw(true)
        self:SetNotSolid(true)
        self:SetLocalVar("ragdolled", entity:EntIndex())
        hook.Run("PlayerRagdolled", self, entity, true)
    elseif IsValid(self.ixRagdoll) then
        self.ixRagdoll:Remove()
        hook.Run("PlayerRagdolled", self, nil, false)
    end
end