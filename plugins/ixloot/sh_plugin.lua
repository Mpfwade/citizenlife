local PLUGIN = PLUGIN

PLUGIN.name = "Lootable Containers"
PLUGIN.author = "Riggs Mackay"
PLUGIN.description = "Allows you to loot certin crates to obtain loot items."

-- doubled the items in the table so that they are more common than anything else. If you get what I mean.
PLUGIN.randomLoot = {}
PLUGIN.randomLoot.common = {
	"metalplate",
	"metalplate",
	"metalplate",
	"metalplate",
	"cloth",
	"cloth",
	"cloth",
	"cloth",
	"cloth",
	"wood",
	"wood",
	"wood",
	"wood",
	"plastic",
	"plastic",
	"plastic",
	"plastic",
	"plastic",
	"plastic",
	"plastic",
	"emptybottle",
	"emptybottle",
	"glue",
	"glue",
	"glue",
	"glue",
	"glue",
	"glue",
	"pipe",
	"pipe",
	"pipe",
	"pipe",
	"gear",
	"gear",
	"gear",
	"gunpowder",
	"gunpowder",
	"rolledcigarettes",
	"rolledcigarettes",
	"bulletcasing",
	"bulletcasing",
}

PLUGIN.randomLoot.rare = {

	"refinedmetal",
	"refinedmetal",
	"pistolammo",
	"pistolammo",
	"pistolammo",
	"bandage",
	"bandage",
	"bandage",
	"bandage",
	"bandage",
	"bandage",
	"bandage",
	"bandage",
	"bandage",
	"bandage",
	"bandage",
	"electronics",
	"electronics",
	"electronics",
	"electronics",
	"crowbar",
	"crowbar",
	"crowbar",
	"rustypipe",
	"rustypipe",
	"rustypipe",
	"rustypipe",
	"rustypipe",
	"rustypipe",
	"katana",

}

ix.util.Include("sv_plugin.lua")
