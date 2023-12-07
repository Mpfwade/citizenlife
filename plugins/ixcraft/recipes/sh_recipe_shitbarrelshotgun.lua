RECIPE.name = "Double Barrel Shotgun"
RECIPE.description = "Craft a Double Barrel Shotgun."
RECIPE.model = "models/weapons/darky_m/rust/w_doublebarrel.mdl"
RECIPE.category = "Weapons (Firearms)"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
    ["plastic"] = 2,
	["metalplate"] = 2,
	["pipe"] = 2,
    ["refinedmetal"] = 1,
    ["wood"] = 1,
}
RECIPE.results = {
	["shitbarrelshotgun"] = 1,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/metal/metal_box_impact_bullet1.wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/metal/metal_box_strain3.wav"