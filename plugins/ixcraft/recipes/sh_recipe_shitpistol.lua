RECIPE.name = "Pistol"
RECIPE.description = "Craft a Pistol."
RECIPE.model = "models/weapons/darky_m/rust/w_nailgun.mdl"
RECIPE.category = "Weapons (Firearms)"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
    ["plastic"] = 5,
    ["metalplate"] = 3,
    ["glue"] = 1,
    ["gear"] = 1,
}
RECIPE.results = {
	["shitpistol"] = 1,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/metal/metal_box_impact_bullet1.wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/metal/metal_box_strain3.wav"