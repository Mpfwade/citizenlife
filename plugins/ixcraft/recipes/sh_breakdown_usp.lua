RECIPE.name = "USP"
RECIPE.description = "Breakdown a USP."
RECIPE.model = "models/weapons/w_pistol.mdl"
RECIPE.category = "Breakdownable"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["usp"] = 1,
}
RECIPE.results = {
	["pipe"] = 1,
	["metalplate"] = 2,
    ["gunscrap"] = 4,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/metal/metal_box_impact_bullet1.wav"
RECIPE.craftTime = 4
RECIPE.craftEndSound = "physics/metal/metal_box_strain3.wav"