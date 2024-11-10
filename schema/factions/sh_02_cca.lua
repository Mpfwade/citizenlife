--[[ Base Config ]]
--
FACTION.name = "Civil Protection"
FACTION.description = [[Name: Civil Protection
Description: The Civil Protection are the Combine's human police force. They are responsible for the enforcement of the Combine's laws, and controlling the population. The Civil Protection consists of multiple divisions, each with a specific role. Many join the Civil Protection in hopes of getting better rations, or simply for the power it brings over their fellow citizens.]]
FACTION.color = Color(0, 51, 153)

--[[ Helix Base Config ]]
--
FACTION.models = {"models/police.mdl",}

FACTION.isGloballyRecognized = true
FACTION.isDefault = false

--[[ Custom Config ]]
--
FACTION.voicelinesHuman = false
FACTION.defaultClass = nil
FACTION.adminOnly = false
FACTION.donatorOnly = false
FACTION.noModelSelection = true
FACTION.command = "ix_faction_become_cca"
FACTION.modelWhitelist = "models/police"

function FACTION:GetDefaultName(client)
    local char = client:GetCharacter()
    if char then
        -- Fetch the rank name from character's data, defaulting to "UNRANKED-UNIT" if not set
        local rankName = char:GetData("ixCombineRank", "UNRANKED-UNIT")

        -- Generate random words and numbers for the name
        local RandomWords = table.Random({"UNION", "HELIX", "HERO", "VICTOR", "KING", "DEFENDER", "ROLLER", "JURY", "GRID", "VICE", "RAZOR", "NOVA", "SPEAR", "JUDGE", "SHIELD", "YELLOW", "LINE", "TAP", "STICK", "QUICK"})
        local RandomNumbers = Schema:ZeroNumber(math.random(1, 99), 2)

        -- Construct the standard name using the rank name
        local StandardName = "c17:" .. rankName .. "." .. RandomWords .. "-" .. RandomNumbers
        return StandardName, true
    end
end

--[[ Plugin Configs ]]
--
FACTION.canSeeWaypoints = true
FACTION.canAddWaypoints = true
FACTION.canRemoveWaypoints = true
FACTION.canUpdateWaypoints = true
--[[ Do not change! ]]
--
FACTION_CCA = FACTION.index