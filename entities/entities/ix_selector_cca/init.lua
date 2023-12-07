AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_combine/combine_dispenser.mdl")
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
end

function ENT:OnTakeDamage()
    return false
end

function ENT:Think()
    if (self.nextTerminalCheck or 0) < CurTime() then
        self:StopSound("ambient/machines/machine1_hit1.wav")
        self:EmitSound("ambient/machines/machine1_hit1.wav", 100)
        self.nextTerminalCheck = CurTime() + math.random(1, 10)
    elseif (self.nextIdle1Check or 0) < CurTime() then
    self:StopSound("ambient/machines/combine_terminal_idle1.wav")
    self:EmitSound("ambient/machines/combine_terminal_idle1.wav", 65)
    self.nextIdle1Check = CurTime() + math.random(5, 90)

elseif (self.nextIdle2Check or 0) < CurTime() then
self:StopSound("ambient/machines/combine_terminal_idle2.wav")
    self:EmitSound("ambient/machines/combine_terminal_idle2.wav", 65)
    self.nextIdle2Check = CurTime() + math.random(5, 90)

elseif (self.nextIdle1Check or 0) < CurTime() then
self:StopSound("ambient/machines/combine_terminal_idle3.wav")
    self:EmitSound("ambient/machines/combine_terminal_idle3.wav", 65)
    self.nextIdle2Check = CurTime() + math.random(5, 90)

    end
end

function ENT:OnRemove()
    self:StopSound("ambient/machines/combine_terminal_idle1.wav")
    self:StopSound("ambient/machines/combine_terminal_idle2.wav")
    self:StopSound("ambient/machines/combine_terminal_idle3.wav")
    self:StopSound("ambient/machines/machine1_hit1.wav")
    self:StopSound("ambient/machines/thumper_startup1.wav")
end

function ENT:AcceptInput(Name, Activator, Caller)
    if (Name == "Use") and Caller:IsPlayer() then
        if Caller:Team() == FACTION_CCA and Caller:GetNWBool("AlreadyaRank", false) == false then
            self:EmitSound("ambient/machines/combine_terminal_idle4.wav")
            Caller:OpenVGUI("LiteNetwork.RankMenu.CCA")
        else
            Caller:ChatPrint("You are not a part of Civil Protection! Or you already have a rank!")
        end
    end
end

concommand.Add("ix_selector_cca", function(ply, cmd, args)
    if not (args[1] and args[2]) then return end

    if not ply:NearEntity("ix_selector_cca") then
        ply:ChatPrint("You need to be near the Combine Civil Authority quartermaster in order to use this!")

        return
    end

    if not (ply:Team() == FACTION_CCA) then
        ply:ChatPrint("You need to become Civil Protection to run this command.")

        return
    end

    if not ((ply.ccaSelectionCoolDown or 0) > CurTime()) then
        local char = ply:GetCharacter()
        if not char then return end

        local RandomWords = table.Random({"UNION", "HELIX", "HERO", "VICTOR", "KING", "DEFENDER", "ROLLER", "JURY", "GRID", "VICE", "RAZOR", "NOVA", "SPEAR", "JUDGE", "SHIELD", "YELLOW", "LINE", "TAP", "STICK", "QUICK"})

        local RandomNumbers = Schema:ZeroNumber(math.random(1, 99), 2)
        local RankID = tonumber(args[1])
        local DivisionID = tonumber(args[2])
        local RankInfo = ix.ranks.cca[RankID]
        local DivisionInfo = ix.divisions.cca[DivisionID]
        local CommandingName = "c17:" .. DivisionInfo.name .. "-" .. RandomNumbers
        local StandardName = "c17:" .. RankInfo.name .. "." .. RandomWords .. "-" .. RandomNumbers

        local BasicWeapons = {"ix_hands", "ix_keys"}

        if not (DivisionInfo.xp == nil) then
            if not (tonumber(ply:GetRP()) >= DivisionInfo.xp) then
                ply:Notify("You do not have the correct amount of Rank Points to become that Division!")

                return false
            end
        end

        if not (DivisionInfo.norank == true) then
            if not (RankInfo.xp == nil) then
                if not (tonumber(ply:GetRP()) >= RankInfo.xp) then
                    ply:Notify("You do not have the correct amount of Rank Points to become that Rank!")

                    return false
                end
            end
        end

        if DivisionInfo.norank == true then
            if CommandingName:find("Tag-Unit") and not (ply:SteamID() == "STEAM_0:1:465730962" or ply:IsSuperAdmin()) then
                ply:Notify("The Commander Division is whitelisted!")

                return false
            end

            if (CommandingName:find("Tag-Unit") and not (ply:SteamID() == "STEAM_0:1:465730962")) and ply:IsSuperAdmin() then
                ply:Notify("You bypassed the whitelist due to you being a superadmin.")
            end

            -- this is probably, the WORST whitelisting system in human kind, but FUCK YOU.. you will not replace this, I spent around 3 hours doing this nigga shit.
            for k, v in pairs(ix.whitelists.CCA.NoRanks) do
                if StandardName:find(k) then
                    if ply:IsSuperAdmin() then
                        ply:Notify("You bypassed the whitelist due to you being a superadmin.")
                    elseif ply:SteamID() == "STEAM_0:1:465730962" then
                        ply:Notify("You are the commander, due that you bypass whitelists.")
                    else
                        if istable(v) then
                            if table.HasValue(v, ply:SteamID()) then
                                ply:Notify("WHITELISTED!!!!!")
                            else
                                ply:Notify("You are not whitelisted.")

                                return false
                            end
                        else
                            if v:find(ply:SteamID()) then
                                ply:Notify("WHITELISTED!!!!!")
                            else
                                ply:Notify("You are not whitelisted.")

                                return false
                            end
                        end
                    end
                end
            end

            ply.ixCCARank = nil
            ply.ixCCADivision = DivisionID
            char:SetName(CommandingName)
            ply:Notify("You are now: " .. CommandingName)

            if DivisionInfo.class then
                char:SetClass(DivisionInfo.class)
            end

            ply:ResetBodygroups()
            ply:SetSkin(DivisionInfo.skin)
            ply:SetMaxHealth(DivisionInfo.health)
            ply:SetHealth(DivisionInfo.health)
            ply:SetArmor(DivisionInfo.armor)
            ply:SetMaxArmor(DivisionInfo.armor)
            ply:SetupHands()

            if DivisionInfo.loadout then
                DivisionInfo.loadout(ply)
            end

            char:SetData("brokenLegs", false)
            char:SetData("ixCombineName", CommandingName)
            Schema:GiveWeapons(ply, BasicWeapons)
        else
            -- this is probably, the WORST whitelisting system in human kind, but FUCK YOU.. you will not replace this, I spent around 3 hours doing this nigga shit.
            local whitelistname = "CCA:" .. RankInfo.name

            for k, v in pairs(ix.whitelists.CCA.Ranks) do
                if whitelistname == k then
                    if ply:IsSuperAdmin() then
                        ply:Notify("You bypassed the whitelist due to you being a superadmin.")
                    elseif ply:SteamID() == "STEAM_0:1:465730962" then
                        ply:Notify("You are the commander, due that you bypass whitelists.")
                    else
                        if istable(v) then
                            if table.HasValue(v, ply:SteamID()) then
                                ply:Notify("WHITELISTED!!!!!")
                            else
                                ply:Notify("You are not whitelisted.")

                                return false
                            end
                        else
                            if v:find(ply:SteamID()) then
                                ply:Notify("WHITELISTED!!!!!")
                            else
                                ply:Notify("You are not whitelisted.")

                                return false
                            end
                        end
                    end
                end
            end

            ply.ixCCARank = RankID
            ply.ixCCADivision = DivisionID
            char:SetName(StandardName)
            ply:Notify("You are now a: " .. StandardName)
            ply:SetNWBool("AlreadyaRank", true)

            if DivisionInfo.class then
                char:SetClass(DivisionInfo.class .. string.upper(RankInfo.name))
            end

            ply:ResetBodygroups()
            ply:SetSkin(DivisionInfo.skin)
            ply:SetMaxHealth(DivisionInfo.health + RankInfo.health)
            ply:SetHealth(DivisionInfo.health + RankInfo.health)
            ply:SetArmor(DivisionInfo.armor + RankInfo.armor)
            ply:SetMaxArmor(DivisionInfo.armor + RankInfo.armor)
            ply:SetModel("models/police.mdl")
            ply:SetupHands()

            timer.Simple(0.1, function()
                if not RankInfo.loadout then
                    if DivisionInfo.loadout then
                        DivisionInfo.loadout(ply)
                    end
                else
                    RankInfo.loadout(ply)
                end
            end)

            char:SetData("brokenLegs", false)
            char:SetData("ixCombineName", StandardName)
            Schema:GiveWeapons(ply, BasicWeapons)

        end

        ply.ccaSelectionCoolDown = CurTime() + 1
    else
        ply:Notify("You need to wait before you can change division and rank again.")
    end
end)