RECIPE.name = "MP7"
RECIPE.description = "Breakdown a MP7."
RECIPE.model = "models/weapons/w_smg1.mdl"
RECIPE.category = "Breakdownable"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["smg"] = 1,
}
RECIPE.results = {
	["pipe"] = 1,
	["metalplate"] = 4,
	["refinedmetal"] = 1,
    ["gunscrap"] = 6,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/metal/metal_box_impact_bullet1.wav"
RECIPE.craftTime = 4
RECIPE.craftEndSound = "physics/metal/metal_box_strain3.wav"