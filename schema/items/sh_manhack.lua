ITEM.name = "Viscerator"
ITEM.description = "The Viscerator, is a gyroscopic device with three razor-sharp blades that constantly spin at extremely high speeds. They are able to cause severe damage to anything they collide with."
ITEM.model = "models/gibs/manhack_gib02.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.bDropOnDeath = true

ITEM.functions.Deploy = {
    name = "Deploy",
    OnRun = function(itemTable)
        local cl = itemTable.player
        cl:ForceSequence("deploy")

        timer.Simple(1.5, function()
            local manhack = ents.Create("npc_manhack")
            manhack:SetPos(cl:GetPos() + Vector(0, 0, 100))
            manhack:Activate()
            manhack:Spawn()

            if cl:IsCombine() then
                manhack:AddEntityRelationship(cl, D_LI, 99)
            end

            if cl:IsRebel() then
                manhack:AddEntityRelationship(cl, D_HT, 99)
            end

            manhack:AddEntityRelationship(cl, D_NU, 99)
        end)
    end,
    OnCanRun = function(itemTable)
        local cl = itemTable.player
        if cl:Team() == FACTION_CCA then return true end
    end
}