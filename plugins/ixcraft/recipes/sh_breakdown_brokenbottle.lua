RECIPE.name = "Beer Bottle"
RECIPE.description = "Breakdown a Beer Bottle."
RECIPE.model = "models/props_junk/GlassBottle01a.mdl"
RECIPE.category = "Breakdownable"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["emptybottle"] = 1,
}
RECIPE.results = {
	["brokenbottle"] = 1,
}

RECIPE.craftStartSound = "physics/metal/metal_box_impact_bullet1.wav"
RECIPE.craftTime = 2
RECIPE.craftEndSound = "physics/metal/metal_box_strain3.wav"