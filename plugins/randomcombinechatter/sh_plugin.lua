
local PLUGIN = PLUGIN
PLUGIN.name = "Combine Chatter Zones"
PLUGIN.author = "Wade"
PLUGIN.description = "Adds Combine Chatter zones so if a player is in the zone it plays chatter."
PLUGIN.schema = "Any"

ix.util.Include('sh_meta.lua')
ix.util.Include('sv_plugin.lua')

    function PLUGIN:SetupAreaProperties()
        ix.area.AddType("chatter")
    end
