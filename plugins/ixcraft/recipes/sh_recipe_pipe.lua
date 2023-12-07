RECIPE.name = "Pipe"
RECIPE.description = "Craft a metal pipe."
RECIPE.model = "models/props_lab/pipesystem03a.mdl"
RECIPE.category = "Miscellaneous"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["metalplate"] = 2,
}
RECIPE.results = {
	["pipe"] = 1,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/metal/metal_box_impact_bullet1.wav"
RECIPE.craftTime = 5
RECIPE.craftEndSound = "physics/metal/metal_box_strain3.wav"