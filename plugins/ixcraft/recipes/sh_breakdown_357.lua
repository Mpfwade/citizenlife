RECIPE.name = "357"
RECIPE.description = "Breakdown a 357."
RECIPE.model = "models/weapons/w_357.mdl"
RECIPE.category = "Breakdownable"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["357"] = 1,
}
RECIPE.results = {
	["pipe"] = 1,
	["refinedmetal"] = 1,
	["gunscrap"] = 7,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/metal/metal_box_impact_bullet1.wav"
RECIPE.craftTime = 5
RECIPE.craftEndSound = "physics/metal/metal_box_strain3.wav"