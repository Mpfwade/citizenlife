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

    function ENT:Use(user)
		if(user:IsCombine() or user:GetCharacter():HasFlags("i")) then
			user:SetAction("Logging in...", 1, function()
				netstream.Start(user, "OpenCCAMenu", {})
				user:Freeze(false)
			end)

			self:EmitSound("buttons/button14.wav", 100, 50)
			user:SelectWeapon("ix_hands")
			user:Freeze(true)
		else
			user:Notify("The terminal is only accessible by the Combine.")
		end
	end
else
	surface.CreateFont("panel_font", {
		["font"] = "verdana",
		["size"] = 12,
		["weight"] = 128,
		["antialias"] = true
	})

        
    end
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
