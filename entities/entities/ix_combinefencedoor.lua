AddCSLuaFile()

ENT.Base = "base_ai"
ENT.Type = "anim"
ENT.PrintName = "Combine Door"
ENT.Author = "ChatGPT"
ENT.Information = "A locked door that can only be opened by one team"
ENT.Instructions = "Press E"
ENT.Category = "IX:HL2RP"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = false

if SERVER then
    -- Initialization of the door, setting model and physical properties
    function ENT:Initialize()
        self:SetModel("models/props_wasteland/interior_fence001g.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self.originalPos = self:GetPos()
        self.originalAngle = self:GetAngles()
        self.openAngle = self.originalAngle + Angle(0, 90, 0)
        self.toggled = false

        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
            phys:EnableMotion(false)
        end
    end

    -- Custom spawn function to position the door correctly when spawned
    function ENT:SpawnFunction(ply, trace)
        if not trace.Hit then return end

        local spawnPos = trace.HitPos + trace.HitNormal * 16
        local ent = ents.Create("ix_combinefencedoor")
        ent:SetPos(spawnPos)
        ent:SetAngles(ply:GetAngles())
        ent:Spawn()
        ent:Activate()

        return ent
    end

    -- Use function defining what happens when a player interacts with the door
    function ENT:Use(activator, caller)
        if IsValid(activator) and activator:IsPlayer() then
            if activator:Team() ~= FACTION_CCA and activator:Team() ~= FACTION_OTA then
                activator:ChatPrint("You cannot use this door!")
                return
            end

            -- Toggle door open or closed
            if self.toggled then
                self:SetPos(self.originalPos)
                self:SetAngles(self.originalAngle)
                self:EmitSound("doors/door_chainlink_close1.wav")
                self.toggled = false
            else
                -- Adjust newPos based on your model's hinge and pivot requirements
                local newPos = self.originalPos + (self:GetRight() * -50)
                self:SetPos(newPos)
                self:SetAngles(self.openAngle)
                self:EmitSound("doors/door_chainlink_move1.wav")
                self.toggled = true
            end
        end
    end
end