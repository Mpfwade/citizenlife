RECIPE.name = "Molotov"
RECIPE.description = "Craft a Molotov."
RECIPE.model = "models/props_junk/GlassBottle01a.mdl"
RECIPE.category = "Weapons (Melee)"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["plastic"] = 1,
	["cloth"] = 2,
	["glue"] = 1,
	["lighter"] = 1,
	["beer"] = 1,
}
RECIPE.results = {
	["molotov"] = 1,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/metal/metal_box_impact_bullet1.wav"
RECIPE.craftTime = 6
RECIPE.craftEndSound = "physics/metal/metal_box_strain3.wav"