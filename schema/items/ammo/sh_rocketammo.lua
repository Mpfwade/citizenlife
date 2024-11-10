-- Item Statistics

ITEM.name = "Box of RPG Missiles"
ITEM.description = "A Package of %s Rockets"
ITEM.category = "Ammo"
ITEM.bDropOnDeath = true
-- Item Configuration

ITEM.model = "models/Items/item_item_crate.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.weight = 2

-- Item Custom Configuration

ITEM.ammo = "rpg_round"
ITEM.ammoAmount = 3

function ITEM:PopulateTooltip(tooltip)
	local illgun = tooltip:AddRow("illgun")
	illgun:SetBackgroundColor(Color(255, 0, 0))
	illgun:SetText("95, illegal carrying (CONTRABAND).")
	illgun:SetFont("DermaDefault")
	illgun:SetExpensiveShadow(0.5)
	illgun:SizeToContents()
end