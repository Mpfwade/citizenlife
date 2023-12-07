ix.ranks.ota = {}
ix.ranks.ota[1] = {
	id = 1,
	name = "OWS",
	description = "Overwatch Soldier",
	xp = 600,
	health = 0,
	armor = 0,
}

ix.ranks.ota[2] = {
	id = 2,
	name = "EOW",
	description = "Elite Overwatch Soldier",
	xp = nil,
	health = 0,
	armor = 20,
	max = 5,
}

ix.ranks.ota[3] = {
	id = 3,
	name = "ORDINAL",
	description = "Leader",
	xp = nil,
	health = 20,
	armor = 65,
	max = 3,
}

ix.divisions.ota = {}
ix.divisions.ota[1] = {
	id = 1,
	name = "ECHO",
	model = "models/jq/hlvr/characters/combine/grunt/combine_grunt_hlvr_npc.mdl",
	model_eow = "models/romka/romka_combine_soldier.mdl",
	model_ldr = "models/jq/hlvr/characters/combine/combine_captain/combine_captain_hlvr_npc.mdl",
	description = "Infantry Unit",
	norank = false,
	skin = 0,
	skin_eow = 0,
	skin_ldr = 0,
	weapons = {},
	health = 100,
	armor = 20,
	max = 10,
	xp = 600,
	class = CLASS_OTA_GRUNT,
}
ix.divisions.ota[1].weapons[1] = {"tfa_osips"}
ix.divisions.ota[1].weapons[2] = {"tfa_ocipr", "weapon_frag"}
ix.divisions.ota[1].weapons[3] = {"tfa_ocipr", "weapon_frag"}

ix.divisions.ota[2] = {
	id = 2,
	name = "WALLHAMMER",
	model = "models/jq/hlvr/characters/combine/heavy/combine_heavy_hlvr_npc.mdl",
	description = "Close Combat Unit",
	norank = true,
	skin = 0,
	weapons = {"tfa_heavyshotgun", "ix_stunstick"},
	health = 120,
	armor = 110,
	max = 3,
	xp = nil,
	class = CLASS_OTA_MACE,
}

ix.divisions.ota[3] = {
	id = 3,
	name = "XRAY",
	model = "models/jq/hlvr/characters/combine/grunt/combine_grunt_hlvr_npc.mdl",
	model_eow = "models/jq/hlvr/characters/combine/grunt/combine_grunt_hlvr_npc.mdl",
	model_ldr = "models/nemez/combine_soldiers/combine_soldier_coordinator_h.mdl",
	description = "Medical Unit",
	norank = false,
	skin = 1,
	skin_eow = 1,
	skin_ldr = 1,
	weapons = {},
	health = 100,
	armor = 25,
	max = 5,
	xp = nil,
	class = CLASS_OTA_XRAY,
}
ix.divisions.ota[3].weapons[1] = {"weapon_medkit", "tfa_osips"}
ix.divisions.ota[3].weapons[2] = {"weapon_medkit", "tfa_osips", "tfa_ins2_usp_match"}
ix.divisions.ota[3].weapons[3] = {"weapon_medkit", "tfa_ocipr", "weapon_frag"}

ix.divisions.ota[4] = {
	id = 4,
	name = "RANGER",
	model = "models/romka/romka_combine_soldier.mdl",
	model_eow = "models/romka/romka_combine_soldier.mdl",
	model_ldr = "models/romka/romka_combine_soldier.mdl",
	description = "Long Range Combat Unit",
	norank = false,
	skin = 7,
	skin_eow = 8,
	skin_ldr = 9,
	weapons = {},
	health = 100,
	armor = 35,
	max = 2,
	xp = nil,
	class = CLASS_OTA_RANGER,
}
ix.divisions.ota[4].weapons[1] = {"grub_combine_sniper", "tfa_ins2_usp_match"}
ix.divisions.ota[4].weapons[2] = {"grub_combine_sniper", "tfa_ins2_usp_match"}
ix.divisions.ota[4].weapons[3] = {"grub_combine_sniper", "tfa_ins2_usp_match", "weapon_frag"}

ix.divisions.ota[5] = {
	id = 5,
	name = "APF",
	model = "models/jq/hlvr/characters/combine/suppressor/combine_suppressor_hlvr_npc.mdl",
	description = "Suppressor Unit",
	norank = true,
	skin = 0,
	weapons = {"tfa_suppressor"},
	health = 200,
	armor = 105,
	max = 3,
	xp = nil,
	class = CLASS_OTA_REAPER,
}

ix.divisions.ota[6] = {
	id = 6,
	name = "OWC",
	model = "models/romka/romka_combine_super_soldier.mdl",
	description = "Commander of the Transhuman Forces",
	norank = true,
	skin = 0,
	weapons = {"weapon_357", "tfa_ocipr", "tfa_ins2_spas12", "weapon_frag"},
	health = 160,
	armor = 200,
	max = 1,
	xp = nil,
	class = CLASS_OTA_COMMANDER,
}