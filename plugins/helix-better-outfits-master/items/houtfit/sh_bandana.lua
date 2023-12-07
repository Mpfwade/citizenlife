-- Item Statistics

ITEM.name = "Bandana"
ITEM.description = "A Bandana, it can be used to hide your identity."
ITEM.category = "Clothing"
ITEM.outfitCategory = "Headstrap"
ITEM.bDropOnDeath = true

-- Item Configuration

ITEM.model = "models/props_lab/box01a.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

ITEM.bodyGroups = {
	["headstrap"] = 6
}


ITEM.allowedModels = {
	"models/humans/pandafishizens/female_01.mdl",
	"models/humans/pandafishizens/female_02.mdl",
	"models/humans/pandafishizens/female_03.mdl",
	"models/humans/pandafishizens/female_04.mdl",
	"models/humans/pandafishizens/female_06.mdl",
	"models/humans/pandafishizens/female_07.mdl",
	"models/humans/pandafishizens/female_11.mdl",
	"models/humans/pandafishizens/female_17.mdl",
	"models/humans/pandafishizens/female_18.mdl",
	"models/humans/pandafishizens/female_19.mdl",
	"models/humans/pandafishizens/female_24.mdl",
	"models/humans/pandafishizens/female_25.mdl",

	"models/humans/pandafishizens/male_01.mdl",
	"models/humans/pandafishizens/male_02.mdl",
	"models/humans/pandafishizens/male_03.mdl",
	"models/humans/pandafishizens/male_04.mdl",
	"models/humans/pandafishizens/male_05.mdl",
	"models/humans/pandafishizens/male_06.mdl",
	"models/humans/pandafishizens/male_07.mdl",
	"models/humans/pandafishizens/male_08.mdl",
	"models/humans/pandafishizens/male_09.mdl",
	"models/humans/pandafishizens/male_10.mdl",
	"models/humans/pandafishizens/male_11.mdl",
	"models/humans/pandafishizens/male_12.mdl",
	"models/humans/pandafishizens/male_15.mdl"


}

function ITEM:PopulateTooltip(tooltip)
	local illitem = tooltip:AddRow("illitem")
	illitem:SetBackgroundColor(Color(255, 0, 0))
	illitem:SetText("69, possession of resources (CONTRABAND).")
	illitem:SetFont("DermaDefault")
	illitem:SetExpensiveShadow(0.5)
	illitem:SizeToContents()
end