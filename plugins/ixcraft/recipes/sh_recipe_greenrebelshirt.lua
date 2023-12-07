RECIPE.name = "Green Resistance Shirt"
RECIPE.description = "Craft a Green Resistance Shirt."
RECIPE.model = "models/tnb/items/shirt_rebel1.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 15,
	["glue"] = 5,
	["plastic"] = 5,
}
RECIPE.results = {
	["grebelshirt2"] = 1,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"