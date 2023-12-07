RECIPE.name = "Dark Blue Resistance Pants"
RECIPE.description = "Craft Dark Blue Resistance Pants."
RECIPE.model = "models/tnb/items/pants_rebel.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 15,
	["plastic"] = 20,
}
RECIPE.results = {
	["brebelpants2"] = 1,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"