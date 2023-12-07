RECIPE.name = "Crossbow"
RECIPE.description = "Breakdown a Crossbow."
RECIPE.model = "models/weapons/w_crossbow.mdl"
RECIPE.category = "Breakdownable"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["crossbow"] = 1,
}
RECIPE.results = {
	["metalplate"] = 3,
	["gear"] = 1,
	["refinedmetal"] = 1,
	["gunscrap"] = 5,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/metal/metal_box_impact_bullet1.wav"
RECIPE.craftTime = 5
RECIPE.craftEndSound = "physics/metal/metal_box_strain3.wav"