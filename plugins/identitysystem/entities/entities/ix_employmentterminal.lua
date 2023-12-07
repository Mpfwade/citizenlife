AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Quiz Term"
ENT.Category = "IX:HL2RP"
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AdminOnly = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_combine/breenconsole.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self.health = 50

        local physObj = self:GetPhysicsObject()
        if IsValid(physObj) then
            physObj:Wake()
        end
    end

    function ENT:Think()
        if (self.nextTerminalCheck or 0) < CurTime() then
            self:StopSound("ambient/machines/combine_terminal_loop1.wav")
            self:EmitSound("ambient/machines/combine_terminal_loop1.wav", 50)
            self.nextTerminalCheck = CurTime() + 10
        end
    end

    function ENT:OnRemove()
        self:StopSound("ambient/machines/combine_terminal_loop1.wav")
    end

    -- Disable taking damage
    function ENT:Use(user)
        local char = user:GetCharacter()
        local inv = char:GetInventory()

        if user:Team() == FACTION_CITIZEN and inv:HasItem("cid") and (self.QuizCooldown or 0) < CurTime() then
            user:SetAction("Logging in...", 1, function()
                netstream.Start(user, "OpenQuizMenu", {})
                user:Freeze(false)
            end)
            self:EmitSound("buttons/button14.wav", 100, 50)
            user:SelectWeapon("ix_ands")
            user:Freeze(true)
            self.QuizCooldown = CurTime() + 5
        elseif not inv:HasItem("cid") then
            user:ChatPrint("You need a CID to use this terminal.")
        elseif (self.QuizCooldown or 0) > CurTime() then
            user:ChatPrint("You need to wait before trying again.")
        end
    end
else
    surface.CreateFont("panel_font", {
        font = "Verdana",
        size = 12,
        weight = 700,
        antialias = true
    })

    function ENT:Draw()
        self:DrawModel()
        local ang = self:GetAngles()
        local pos = self:GetPos() + ang:Up() * 48 + ang:Right() * -5 + ang:Forward() * -9.75
        ang:RotateAroundAxis(ang:Forward(), 42)
        cam.Start3D2D(pos, ang, 0.1)
        local width, height = 155, 77
        surface.SetDrawColor(Color(16, 16, 16))
        surface.DrawRect(0, 0, width, height)
        surface.SetDrawColor(Color(255, 255, 255, 16))
        surface.DrawRect(0, height / 2 + math.sin(CurTime() * 4) * height / 2, width, 1)
        local alpha = 191 + 64 * math.sin(CurTime() * 4)

        if not self:GetNetVar("InUse", false) then
            draw.SimpleText("Application Terminal", "panel_font", width / 2, 25, Color(90, 210, 255, alpha), TEXT_ALIGN_CENTER)
            draw.SimpleText("Waiting for input", "panel_font", width / 2, height - 16, Color(205, 255, 180, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(LocalPlayer():SteamID64(), "panel_font", 5, 36, Color(90, 210, 255, alpha))
            draw.SimpleText("Validating Input...", "panel_font", 5, 46, Color(102, 255, 255, alpha))
        end

        cam.End3D2D()
    end
end
