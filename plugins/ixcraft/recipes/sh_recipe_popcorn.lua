RECIPE.name = "Popcorn"
RECIPE.description = "Cook popcorn."
RECIPE.model = "models/bioshockinfinite/topcorn_bag.mdl"
RECIPE.category = "Consumeables (Foods)"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["corn"] = 1,
    ["cheese"] = 1,
}
RECIPE.results = {
	["popcorn"] = 1,
}

RECIPE.station = "ix_cookstation"
RECIPE.craftStartSound = "npc/antlion_grub/squashed.wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "npc/antlion_grub/squashed.wav"