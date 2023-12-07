RECIPE.name = "Alien Meat."
RECIPE.description = "Make Alien Meat."
RECIPE.model = "models/willardnetworks/food/cooked_alienmeat.mdl"
RECIPE.category = "Consumeables (Foods)"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["alienrawmeat"] = 1,
	["water_special"] = 2,
	["water"] = 1,
}
RECIPE.results = {
	["aliencookedmeat"] = 1,
}

RECIPE.station = "ix_cookstation"
RECIPE.craftStartSound = "npc/antlion_grub/squashed.wav"
RECIPE.craftTime = 13
RECIPE.craftEndSound = "npc/antlion_grub/squashed.wav"