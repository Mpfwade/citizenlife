ITEM.name = "Molotov"
ITEM.description = "Its a breakable glass bottle containing a flammable substance such as petrol, alcohol, or a napalm-like mixture, with some motor oil added."
ITEM.model = "models/props_junk/GlassBottle01a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.isGrenade = true
ITEM.bDropOnDeath = true
ITEM.functions.use = {
    name = "Equip",
    tip = "equipTip",
    icon = "icon16/tick.png",
    OnRun = function(itemTable)
        local ply = itemTable.player

        ply:Give("ls_molotov")
        ply:SelectWeapon( "ls_molotov" )
        ply:SetAmmo(1, ply:GetActiveWeapon():GetPrimaryAmmoType())
    end
}
