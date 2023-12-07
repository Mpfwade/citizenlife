RECIPE.name = "SPAS-12"
RECIPE.description = "Breakdown a SPAS-12."
RECIPE.model = "models/weapons/w_shotgun.mdl"
RECIPE.category = "Breakdownable"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["spas12"] = 1,
}
RECIPE.results = {
	["pipe"] = 1,
	["metalplate"] = 6,
	["refinedmetal"] = 1,
    ["gunscrap"] = 10,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/metal/metal_box_impact_bullet1.wav"
RECIPE.craftTime = 4
RECIPE.craftEndSound = "physics/metal/metal_box_strain3.wav"