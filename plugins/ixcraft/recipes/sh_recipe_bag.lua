RECIPE.name = "Bag"
RECIPE.description = "Craft a Bag."
RECIPE.model = "models/props_junk/cardboard_box003b.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 20,
}
RECIPE.results = {
	["bag"] = 1,
}

RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"