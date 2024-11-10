-- Item Statistics

ITEM.name = "9mm Pistol Bullets"
ITEM.description = "A Box that contains %s of Pistol Ammo"
ITEM.category = "Ammo"
ITEM.bDropOnDeath = true
-- Item Configuration

ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1
ITEM.weight = 0.68

-- Item Custom Configuration

ITEM.ammo = "Pistol"
ITEM.ammoAmount = 30

ITEM.exRender = true
ITEM.iconCam = {
	pos = Vector(-200.06, 1.3, 9.08),
	ang = Angle(0.89, -0.52, 0),
	fov = 6.68
}

function ITEM:PopulateTooltip(tooltip)
	local illgun = tooltip:AddRow("illgun")
	illgun:SetBackgroundColor(Color(255, 0, 0))
	illgun:SetText("95, illegal carrying (CONTRABAND).")
	illgun:SetFont("DermaDefault")
	illgun:SetExpensiveShadow(0.5)
	illgun:SizeToContents()
end