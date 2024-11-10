-- Item Statistics

ITEM.name = "Pulse-Rifle Energy"
ITEM.description = "A Cartridge that contains %s of AR2 Ammo"
ITEM.category = "Ammo"
ITEM.bDropOnDeath = true
-- Item Configuration

ITEM.model = "models/items/combine_rifle_cartridge01.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1
ITEM.weight = 0.90

-- Item Custom Configuration

ITEM.ammo = "ar2"
ITEM.ammoAmount = 30

function ITEM:PopulateTooltip(tooltip)
	local illgun = tooltip:AddRow("illgun")
	illgun:SetBackgroundColor(Color(255, 0, 0))
	illgun:SetText("95, illegal carrying (CONTRABAND).")
	illgun:SetFont("DermaDefault")
	illgun:SetExpensiveShadow(0.5)
	illgun:SizeToContents()
end