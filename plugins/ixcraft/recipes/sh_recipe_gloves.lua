RECIPE.name = "Black Gloves"
RECIPE.description = "Craft Gloves."
RECIPE.model = "models/tnb/items/gloves.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 6,
}
RECIPE.results = {
	["gloves"] = 1,
}

RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 5
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"