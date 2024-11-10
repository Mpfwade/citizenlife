--[[ Base Config ]]--

FACTION.name = "Vortigaunt"
FACTION.description = [[Name: Vortigaunt
Description: A mysterious alien race, enslaved by the Combine. They are a wise and mainly peaceful race, forced into servitude by other races for centuries. They stayed hidden on Xen until the human scientists at Black Mesa opened a portal to it. Nihilanth used this opportunity to begin invading Earth, sending hordes of Vortigaunts, headcrabs and other creatures into this new realm. The death of the powerful Nihilanth actually made the rip in space-time worse, causing worldwide portal storms that lead to the invasion of the earth by the Combine.]]
FACTION.color = Color(150, 125, 50)
FACTION.weapons = {"ls_broom"}


--[[ Helix Base Config ]]--

FACTION.models = {
	"models/willardnetworks/vortigaunt.mdl",
}

FACTION.isGloballyRecognized = true
FACTION.isDefault = false


--[[ Custom Config ]]--

FACTION.voicelinesHuman = false
FACTION.defaultClass = nil
FACTION.adminOnly = false
FACTION.donatorOnly = true
FACTION.noModelSelection = true
FACTION.command = "ix_faction_become_vortigaunt"
FACTION.modelWhitelist = "willardnetworks/vortigaunt"

--[[ Do not change! ]]--

FACTION_VORTIGAUNT = FACTION.index