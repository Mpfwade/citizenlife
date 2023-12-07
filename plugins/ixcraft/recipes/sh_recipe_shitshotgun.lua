RECIPE.name = "Shotgun"
RECIPE.description = "Craft a Shotgun."
RECIPE.model = "models/weapons/yurie_rustalpha/wm-pipeshotgun.mdl"
RECIPE.category = "Weapons (Firearms)"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["metalplate"] = 2,
    ["wood"] = 2,
    ["gunscrap"] = 1,
	["pipe"] = 1,
}
RECIPE.results = {
	["shitshotgun"] = 1,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/metal/metal_box_impact_bullet1.wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/metal/metal_box_strain3.wav"