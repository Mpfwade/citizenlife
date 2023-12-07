AddCSLuaFile()
ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "Process Term"
ENT.Category = "IX:HL2RP"
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AdminOnly = true

if SERVER then
    util.AddNetworkString("ProcessorActionConfirmation")
    util.AddNetworkString("PlayJobAcceptedSound")
    util.AddNetworkString("StopJobAcceptedSound")

    function ENT:Initialize()
        self:SetModel("models/props_lab/reciever_cart.mdl")
        self:SetSolid(SOLID_VPHYSICS)
        --self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self.health = 50
    end

    function ENT:Think()
        if (self.nextTerminalCheck or 0) < CurTime() then
            self:StopSound("ambient/levels/labs/equipment_printer_loop1.wav")
            self:EmitSound("ambient/levels/labs/equipment_printer_loop1.wav", 50)
            self:StopSound("ambient/levels/labs/equipment_beep_loop1.wav")
            self:EmitSound("ambient/levels/labs/equipment_beep_loop1.wav", 50)
            self.nextTerminalCheck = CurTime() + 10
        end
    end

    function ENT:OnRemove()
        self:StopSound("ambient/levels/labs/equipment_printer_loop1.wav")
        self:StopSound("ambient/levels/labs/equipment_beep_loop1.wav")
    end

    if SERVER then
        util.AddNetworkString("ProcessorActionConfirmation")

        function ENT:Use(user)
            local char = user:GetCharacter()
            local inv = char:GetInventory()

            if user:Team() == FACTION_CITIZEN and inv:HasItem("cp_papers") then
                user:SetAction("Putting paper in...", 1, function()
                    -- Display a warning message on the player's screen
                    net.Start("ProcessorActionConfirmation")
                    net.Send(user)

                    -- Wait for the player's response
                    net.Receive("ProcessorActionConfirmation", function(_, ply)
                        local confirmed = net.ReadBool()

                        if confirmed then
                            net.Start("PlayJobAcceptedSound") -- Send a network message to play the sound on the client
                            net.Send(user)

                            timer.Simple(23.5, function()
                                user:Freeze(false)
                                char:SetFaction(FACTION_CCA)
                                char:SetModel("models/police.mdl")
                                char:SetName("UNRANKED-UNIT")
                                user:SetWhitelisted(FACTION_CCA, true)
                                hook.Run("PlayerLoadout", user)
                                user:ResetBodygroups()

                                for _, item in pairs(inv:GetItems()) do
                                    item:Remove()
                                end
        
                                net.Start("StopJobAcceptedSound") -- Send a network message to stop the sound on the client
                                net.Send(user)

                                timer.Simple(0.30, function()
                                    user:Spawn()
                                    char:SetClass(nil)
                                end)
                            end)
                        else
                            user:ChatPrint("Processing canceled.")
                            user:SelectWeapon("ix_hands")
                            user:Freeze(false)
                            user:SetAction()
                        end
                    end)
                end)

                self:EmitSound("ambient/machines/keyboard7_clicks_enter.wav", 100, 50)
                user:SelectWeapon("ix_hands")
                user:Freeze(true)
            else
                user:ChatPrint("You need acceptance paper to use this terminal.")
            end
        end
    end
else
    function ENT:Draw()
        self:DrawModel()
        local ang = self:GetAngles() + Angle(180, 0, 0)
        local pos = self:GetPos() + ang:Up() * -10 + ang:Right() * -13 + ang:Forward() * -9.75
        ang:RotateAroundAxis(ang:Forward(), -90)
    end

    if CLIENT then
        net.Receive("PlayJobAcceptedSound", function()
            local user = LocalPlayer()
            user.JobAcceptedMusicPatch = CreateSound(user, "music/hl2_song25_teleporter.mp3")
            user.JobAcceptedMusicPatch:PlayEx(75, 100)
        end)

        net.Receive("StopJobAcceptedSound", function()
            local user = LocalPlayer()

            if user.JobAcceptedMusicPatch then
                user.JobAcceptedMusicPatch:FadeOut(1)
            end
        end)
    end
end
