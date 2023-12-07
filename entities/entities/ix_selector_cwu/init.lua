AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/snood_17/male_04.mdl")
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()
end

function ENT:OnTakeDamage()
    return false
end

util.AddNetworkString("ixSelector.CWU.NotAllowed")
util.AddNetworkString("ixSelector.CWU.SetClass")

function ENT:AcceptInput(Name, Activator, Caller)
    if (Name == "Use") and Caller:IsPlayer() then
        self:SetEyeTarget(Caller:EyePos())

        if Caller:Team() == FACTION_CITIZEN then
            self:EmitSound("vo/npc/male01/hi0" .. math.random(1, 2) .. ".wav")
            Caller:OpenVGUI("LiteNetwork.RankMenu.CWU")
        else
            net.Start("ixSelector.CWU.NotAllowed")
            net.Send(Caller)
            self:EmitSound("vo/trainyard/male01/cit_pedestrian0" .. math.random(1, 5) .. ".wav")
            Caller:ChatPrint("You are not a Citizen!")
        end
    end
end

concommand.Add("ix_selector_cwu", function(ply, cmd, args)
    if not args[1] then return end

    if not ply:NearEntity("ix_selector_cwu") then
        ply:ChatPrint("You need to be near the Worker quartermaster in order to use this!")

        return
    end

    if not (ply:Team() == FACTION_CITIZEN) then
        ply:ChatPrint("You need to become a Citizen to run this command.")

        return
    end

    if not ((ply.cwuSelectionCoolDown or 0) > CurTime()) then
        local char = ply:GetCharacter()
        if not char then return end
        local JobID = tonumber(args[1])
        local JobInfo = ix.divisions.cwu[JobID]

        if not (JobInfo.xp == nil) then
            if not (tonumber(ply:GetLP()) >= JobInfo.xp) then
                ply:ChatPrint("You do not have the correct amount of Loyalty Points to become that job!")

                return false
            end
        end

        if ply:IsValid() and ply:GetCharacter() then
            local character = ply:GetCharacter()
            local inventory = character:GetInventory()

            -- Iterate through each item in the character's inventory
            for _, item in pairs(inventory:GetItems()) do
                -- Check if the item is equipped and in the Outfit category
                if item:GetData("equip") and item.category == "Clothing" or item.category == "Cloths/Outfits" then
                    -- Unequip the item
                    item:RemoveOutfit(ply)
					item:SetData("equip", false)
					item:OnUnequipped()
                elseif item.category == "Armor Items" or item.category == "Weapons" or item.category == "Weapons" and item.category == "Armor Items" then
                    ply:ChatPrint("You cannot change your job while having illegal items!")
					return false
                end
            end

            ply:ChatPrint("You are now a " .. JobInfo.name .. "!")

            if JobInfo.class and char then
                char:SetClass(JobInfo.class)

                if char:GetClass(JobInfo.class) then
                    print("You are now a:" .. JobInfo.class .. " ")
                end
            end

            if JobInfo.model then
                ply:SetModel(JobInfo.model)
            else
                if not ply:GetModel():find("humans/pandafishizens") then
                    ply:SetModel(table.Random(ix.faction.Get(ply:Team()).models))
                end
            end

            ply:ResetBodygroups()

            if JobInfo.loadout then
                JobInfo.loadout(ply)
            end

            ply:SetupHands()
            ply.ixCWUClass = JobInfo.id
            net.Start("ixSelector.CWU.SetClass")
            net.WriteUInt(ply.ixCWUClass or 0, 3)
            net.Send(ply)
            ply.cwuSelectionCoolDown = CurTime() + 10
        else
            ply:ChatPrint("You need to wait before you can get your Job again.")
        end
    end
end)