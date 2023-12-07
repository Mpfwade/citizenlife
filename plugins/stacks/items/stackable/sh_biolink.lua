-- Item Statistics

ITEM.name = "Destroyed Biolink"
ITEM.description = "An Destroyed Biolink from an Metropolice Unit."
ITEM.category = "Items"
ITEM.bDropOnDeath = true

-- Item Configuration

ITEM.model = "models/gibs/manhack_gib03.mdl"
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