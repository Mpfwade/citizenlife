ITEM.name = "Ration"
ITEM.description = "A shrink-wrapped packet containing some food and money."
-- Item Configuration
ITEM.model = "models/weapons/w_package.mdl"
ITEM.skin = 0
ITEM.noBusiness = true
ITEM.exRender = true
ITEM.bDropOnDeath = true

ITEM.iconCam = {
    pos = Vector(1.96, 5.95, 199.77),
    ang = Angle(86.31, 276.88, 0),
    fov = 6.82
}

ITEM.functions.Open = {
    icon = "icon16/box.png",
    OnRun = function(itemTable)
        local ply = itemTable.player
        local character = ply:GetCharacter()
        local tokenReward = itemTable.money

        if (character:GetClass() == CLASS_CWU_WORKER or character:GetClass() == CLASS_CWU_COOK or character:GetClass() == CLASS_CWU_MEDIC or character:GetClass() == CLASS_CWU_DIRECTOR) then
            tokenReward = 35
            character:GetInventory():Add("cwusupplements", 1)
        elseif ply:Team() == FACTION_CCA then
            tokenReward = 100
            character:GetInventory():Add("combinesupplements", 1)
        elseif ply:Team() == FACTION_OTA then
            tokenReward = 210
        else
            tokenReward = 25
            character:GetInventory():Add("citizensupplements", 1)
            ply:SetLP(3 + ply:GetNWInt("ixLP")) -- change to 1 lp later when I have others ways of getting lp
        end

        character:GiveMoney(tokenReward)
        ply:EmitSound("physics/plastic/plastic_barrel_break" .. math.random(1, 2) .. ".wav", 80)
    end
}

function ITEM:OnEntityTakeDamage(ent, dmg)
    return false
end
