RECIPE.name = "Glasses"
RECIPE.description = "Craft Glasses."
RECIPE.model = "models/props_lab/box01a.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["plastic"] = 5,
	["glue"] = 3,
}
RECIPE.results = {
	["glasses"] = 1,
}

RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"