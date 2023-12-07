RECIPE.name = "Cereal"
RECIPE.description = "Make Cereal."
RECIPE.model = "models/bioshockinfinite/hext_cereal_box_cornflakes.mdl"
RECIPE.category = "Consumeables (Foods)"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["milk"] = 1,
	["nuts"] = 1,
}
RECIPE.results = {
	["cereal"] = 1,
}

RECIPE.station = "ix_cookstation"
RECIPE.craftStartSound = "npc/antlion_grub/squashed.wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "npc/antlion_grub/squashed.wav"