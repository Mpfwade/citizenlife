RECIPE.name = "Green Beanie"
RECIPE.description = "Craft a Green Beanie."
RECIPE.model = "models/props_junk/cardboard_box003b.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 7,
}
RECIPE.results = {
	["greenbeanie"] = 1,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 5
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"