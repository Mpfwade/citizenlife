RECIPE.name = "Revolver"
RECIPE.description = "Craft a Revolver."
RECIPE.model = "models/weapons/yurie_rustalpha/wm-revolver.mdl"
RECIPE.category = "Weapons (Firearms)"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["metalplate"] = 2,
    ["gunscrap"] = 1,
	["gear"] = 1,
}
RECIPE.results = {
	["shitrevolver"] = 1,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/metal/metal_box_impact_bullet1.wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/metal/metal_box_strain3.wav"