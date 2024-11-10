AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("FactionChangeFade")

function ENT:Initialize()
    self:SetModel("models/props_c17/Lockers001a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
        phys:EnableMotion(false)
    end
end

function ENT:SpawnFunction(ply, trace)
    local entity = ents.Create("ix_CCA_locker")
    entity:SetPos(trace.HitPos)
    entity:SetAngles(Angle(0, (entity:GetPos() - ply:GetPos()):Angle().y - 180, 0))
    entity:Spawn()
    entity:Activate()

    return entity
end

function ENT:OnTakeDamage()
    return false
end

local function GenerateCCAName(client)
    local char = client:GetCharacter()
    if char then
        local rankName = char:GetData("ixCombineRank", "UNRANKED-UNIT")
        local RandomWords = table.Random({"UNION", "HELIX", "HERO", "VICTOR", "KING", "DEFENDER", "ROLLER", "JURY", "GRID", "VICE", "RAZOR", "NOVA", "SPEAR", "JUDGE", "SHIELD", "YELLOW", "LINE", "TAP", "STICK", "QUICK"})
        local RandomNumbers = Schema:ZeroNumber(math.random(1, 99), 2)

        local StandardName = "c17:" .. rankName .. "." .. RandomWords .. "-" .. RandomNumbers
        return StandardName
    end
end

function ENT:AcceptInput(Name, Activator, ply)
    if (Name == "Use" and ply:IsPlayer()) then
        local character = ply:GetCharacter()
        local currentFaction = character:GetFaction()

        if (currentFaction == FACTION_CITIZEN) or (currentFaction == FACTION_CCA) then
            self:EmitSound("doors/door_metal_thin_open1.wav")
            ply:Freeze(true)

            net.Start("FactionChangeFade")
            net.WriteBool(true)
            net.Send(ply)

            timer.Simple(5, function()
                if (currentFaction == FACTION_CITIZEN) then
                    -- Store the player's current citizen model, name, and description
                    character:SetData("citizenModel", ply:GetModel())
                    character:SetData("citizenName", character:GetName())
                    character:SetData("citizenDesc", character:GetDescription())  -- Store original description

                    -- Change to the CCA model and generate a new name
                    character:SetModel("models/police.mdl")
                    ply:SetModel("models/police.mdl")
                    local ccaName = GenerateCCAName(ply)
                    character:SetName(ccaName)

                    -- Save the CCA model to character data
                    character:SetData("ccaModel", "models/police.mdl")

                    -- Update faction to CCA and set the new description
                    character:SetFaction(FACTION_CCA)
                    character:SetDescription("A standard civil protection officer, indistinguishable from the rest")
                    ply:Notify("You are now a member of the Civil Protection.")

                elseif (currentFaction == FACTION_CCA) then
                    -- If switching back to Citizen, restore original name, model, and description
                    local citizenModel = character:GetData("citizenModel", "models/humans/group01/male_01.mdl")
                    local citizenName = character:GetData("citizenName", character:GetName())
                    local citizenDesc = character:GetData("citizenDesc", character:GetDescription())
                    character:SetModel(citizenModel)
                    ply:SetModel(citizenModel)
                    character:SetName(citizenName)
                    character:SetDescription(citizenDesc)  -- Restore original description

                    -- Update faction to Citizen
                    character:SetFaction(FACTION_CITIZEN)
                    ply:Notify("You are now a Citizen.")
                end

                net.Start("FactionChangeFade")
                net.WriteBool(false)
                net.Send(ply)
            end)

            timer.Simple(5, function()
                ply:Freeze(false)
                ply:EmitSound("doors/door_metal_thin_close2.wav")
            end)
        else
            ply:Notify("Your faction cannot use this locker!")
        end
    end
end