RECIPE.name = "Phone"
RECIPE.description = "Craft a Phone."
RECIPE.model = "models/props_trainstation/payphone_reciever001a.mdl"
RECIPE.category = "Miscellaneous"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["plastic"] = 10,
	["glue"] = 4,
	["electronics"] = 1,
}
RECIPE.results = {
	["phone"] = 1,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/metal/metal_box_impact_bullet1.wav"
RECIPE.craftTime = 40
RECIPE.craftEndSound = "physics/metal/metal_box_strain3.wav"