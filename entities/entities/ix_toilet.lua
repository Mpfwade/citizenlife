AddCSLuaFile()

ENT.Base = "base_ai"
ENT.Type = "anim"
ENT.PrintName = "Toilet"
ENT.Author = "Wade"
ENT.Information = "It makes sound"
ENT.Purpose = "For poop."
ENT.Instructions = "Press E"
ENT.Category = "IX:HL2RP"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/hunter/blocks/cube05x05x05.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        local phys = self:GetPhysicsObject()

        if phys:IsValid() then
            phys:Wake()
            phys:EnableMotion(false)
        end

        self.notFlushed = true -- Initialize the member variable
    end

    function ENT:SpawnFunction(ply, trace)
        local entity = ents.Create("ix_toilet")
        entity:SetPos(trace.HitPos)
        entity:SetAngles(Angle(0, (entity:GetPos() - ply:GetPos()):Angle().y - 180, 0))
        entity:Spawn()
        entity:Activate()

        return entity
    end
end

function ENT:Use(activator, caller)
    if IsValid(activator) and activator:IsPlayer() and self.notFlushed then
        self:EmitSound("ambient/machines/usetoilet_flush1.wav")
        self.notFlushed = false

        timer.Simple(5, function()
            self.notFlushed = true
        end)
    end
end
