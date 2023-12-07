RECIPE.name = "Rusty Pipe"
RECIPE.description = "Craft a Rusty Pipe."
RECIPE.model = "models/props_canal/mattpipe.mdl"
RECIPE.category = "Weapons (Melee)"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["metalplate"] = 2,
	["pipe"] = 1,
}
RECIPE.results = {
	["rustypipe"] = 1,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/metal/metal_box_impact_bullet1.wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/metal/metal_box_strain3.wav"