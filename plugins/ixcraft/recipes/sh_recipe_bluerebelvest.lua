RECIPE.name = "Blue Resistance Shirt with Vest"
RECIPE.description = "Craft a Blue Resistance Shirt with Vest."
RECIPE.model = "models/tnb/items/shirt_rebel1.mdl"
RECIPE.category = "Armor Items"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["damagedcpvest"] = 1,
	["cloth"] = 3,
	["glue"] = 1,
	["plastic"] = 2,
}
RECIPE.results = {
	["brebelshirt1"] = 1,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 25
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"