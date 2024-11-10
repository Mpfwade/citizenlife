local PLUGIN = PLUGIN

PLUGIN.name = "Lockerfix"
PLUGIN.author = "Citizenlifedev"
PLUGIN.description = "Fixes Locker issues"

function PLUGIN:PlayerLoadedCharacter(client, character)
    if character:GetFaction() == FACTION_CCA then
        local targetFaction = ix.faction.Get("citizen")

        if targetFaction then
            character:SetFaction(targetFaction.uniqueID)
        end
    end
end
