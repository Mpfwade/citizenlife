RECIPE.name = "Beer"
RECIPE.description = "Make Beer."
RECIPE.model = "models/props_junk/garbage_glassbottle003a.mdl"
RECIPE.category = "Consumeables (Foods)"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["supplements"] = 1,
	["water_sparkling"] = 1,
    ["water_special"] = 1,
}
RECIPE.results = {
	["beer"] = 1,
}

RECIPE.station = "ix_cookstation"
RECIPE.craftStartSound = "npc/antlion_grub/squashed.wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "npc/antlion_grub/squashed.wav"