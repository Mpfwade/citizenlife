ENT.Type = "anim"
ENT.PrintName = "Seaming Machine"
ENT.Category = "IX:HL2RP"
ENT.Spawnable = true
ENT.AdminOnly = true

if (SERVER) then
    function ENT:Initialize()
        self:SetModel("models/combine_room/combine_monitor001temp.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        local physObj = self:GetPhysicsObject()

        if (IsValid(physObj)) then
            physObj:EnableMotion(true)
            physObj:Wake()
        end
    end

    function ENT:SpawnFunction(ply, trace)
        local angles = ply:GetAngles()
    
        local entity = ents.Create("ix_seamingmachine")
        entity:SetPos(trace.HitPos)
        entity:SetAngles(Angle(0, (entity:GetPos() - ply:GetPos()):Angle().y - 180, 0))
        entity:Spawn()
        entity:Activate()
    
        return entity
    end
end