-- Item Statistics

ITEM.name = "Bullet Casing"
ITEM.description = "A metal casing for bullets."
ITEM.category = "Items"
ITEM.bDropOnDeath = true

-- Item Configuration

ITEM.model = "models/items/ar2_grenade.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

-- Item Custom Configuration

ITEM.maxStacks = 10

function ITEM:PopulateTooltip(tooltip)
	local illitem = tooltip:AddRow("illitem")
	illitem:SetBackgroundColor(Color(255, 0, 0))
	illitem:SetText("69, possession of resources (CONTRABAND).")
	illitem:SetFont("DermaDefault")
	illitem:SetExpensiveShadow(0.5)
	illitem:SizeToContents()
end