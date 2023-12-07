ITEM.name = "Blue Resistance Shirt"
ITEM.description = "A blue, long-sleeved shirt with a belt."
ITEM.model = "models/tnb/items/shirt_rebel1.mdl"
ITEM.skin = 1
ITEM.outfitCategory = "Shirts"
ITEM.noResetBodyGroups = true
ITEM.bDropOnDeath = true
ITEM.fitData = "bluerebshirt2"


ITEM.bodyGroups = {
	["torso"] = 13,
	["belt"] = 1,
	["armband"] = 1,
}

ITEM.height = 1
ITEM.width = 1
ITEM.category = "Armor Items"

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

ITEM.fitArmor = 15

function ITEM:PopulateTooltip(tooltip)
	local illitem = tooltip:AddRow("illitem")
	illitem:SetBackgroundColor(Color(255, 0, 0))
	illitem:SetText("69, possession of resources (CONTRABAND).")
	illitem:SetFont("DermaDefault")
	illitem:SetExpensiveShadow(0.5)
	illitem:SizeToContents()
end