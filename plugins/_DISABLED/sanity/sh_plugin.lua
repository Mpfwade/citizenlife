local PLUGIN = PLUGIN

PLUGIN.name = "Sanity"
PLUGIN.author = "Scotnay"
PLUGIN.description = "Adds in a simple sanity system that can effect how you perceive the world!"

ix.util.Include( "cl_hooks.lua" )
ix.util.Include( "sv_hooks.lua" )
ix.util.Include( "sh_meta.lua" )

PLUGIN.noSanity = {
  [ FACTION_OTA ] = true,
  [ FACTION_CCA ] = true,
  [ FACTION_VORTIGAUNT ] = true,
  [ FACTION_DISPATCH ] = true
}

function PLUGIN:CheckSanity( character )
  local faction = character:GetFaction()
  return self.noSanity[ faction ]
end
