RECIPE.name = "Pickaxe"
RECIPE.description = "Craft a Pickaxe."
RECIPE.model = "models/weapons/hl2meleepack/w_pickaxe.mdl"
RECIPE.category = "Weapons (Melee)"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["metalplate"] = 15,
	["wood"] = 3,
}
RECIPE.results = {
	["pickaxe"] = 1,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/metal/metal_box_impact_bullet1.wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/metal/metal_box_strain3.wav"