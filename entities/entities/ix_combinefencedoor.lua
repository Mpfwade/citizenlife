AddCSLuaFile()
ENT.Base = "base_ai"
ENT.Type = "anim"
ENT.PrintName = "Combine Door"
ENT.Author = "ChatGPT"
ENT.Information = "A locked door that can only be opened by one team"
ENT.Purpose = "Give out Ammo for certain weapons."
ENT.Instructions = "Press E"
ENT.Category = "IX:HL2RP"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_wasteland/interior_fence001g.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self.originalPos = self:GetPos() -- Store the original position of the entity
        self.newPos = self.originalPos + Vector(0, 50, 0) -- Calculate the new position of the entity
        self.toggled = false -- Set the initial toggle state to false
        local phys = self:GetPhysicsObject()

        if phys:IsValid() then
            phys:Wake()
            phys:EnableMotion(false)
        end
    end

    function ENT:SpawnFunction(ply, trace)
        local angles = ply:GetAngles()
        local entity = ents.Create("ix_combinefencedoor")
        entity:SetPos(trace.HitPos)
        entity:SetAngles(Angle(0, (entity:GetPos() - ply:GetPos()):Angle().y - 180, 0))
        entity:Spawn()
        entity:Activate()

        return entity
    end

    function ENT:Use(activator, caller)
        if IsValid(activator) and activator:IsPlayer() then
            if activator:Team() ~= FACTION_CCA and activator:Team() ~= FACTION_OTA then
                activator:ChatPrint("You cannot use this door!")
                return
            end

            if self.toggled then
                self:SetPos(self.originalPos) -- Set the entity's position to the original position
                self:EmitSound("doors/door_chainlink_close1.wav")
                self.toggled = false -- Set the toggle state to false
            else
                self:SetPos(self.newPos) -- Set the entity's position to the new position
                self:EmitSound("doors/door_chainlink_move1.wav")
                self.toggled = true -- Set the toggle state to true
            end
        end
    end
end
