RECIPE.name = "Playing Cards"
RECIPE.description = "Craft Playing Cards."
RECIPE.model = "models/props_lab/box01a.mdl"
RECIPE.category = "Miscellaneous"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["plastic"] = 3,
    ["cloth"] = 1,
}
RECIPE.results = {
	["playingcards"] = 1,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/metal/metal_box_impact_bullet1.wav"
RECIPE.craftTime = 5
RECIPE.craftEndSound = "physics/metal/metal_box_strain3.wav"