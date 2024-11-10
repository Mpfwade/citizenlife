-- Item Statistics

ITEM.name = "SMG Bullets"
ITEM.description = "A Box that contains %s of SMG Ammo"
ITEM.category = "Ammo"
ITEM.bDropOnDeath = true
-- Item Configuration

ITEM.model = "models/Items/BoxMRounds.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1
ITEM.weight = 0.68

-- Item Custom Configuration

ITEM.ammo = "smg1"
ITEM.ammoAmount = 45

function ITEM:PopulateTooltip(tooltip)
	local illgun = tooltip:AddRow("illgun")
	illgun:SetBackgroundColor(Color(255, 0, 0))
	illgun:SetText("95, illegal carrying (CONTRABAND).")
	illgun:SetFont("DermaDefault")
	illgun:SetExpensiveShadow(0.5)
	illgun:SizeToContents()
end