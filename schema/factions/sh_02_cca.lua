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
FACTION.payTime = 600
FACTION.pay = 0
--[[ Custom Config ]]
--
FACTION.voicelinesHuman = false
FACTION.defaultClass = nil
FACTION.adminOnly = false
FACTION.donatorOnly = false
FACTION.noModelSelection = true
FACTION.command = "ix_faction_become_cca"
FACTION.modelWhitelist = "models/police"

if SERVER then
    util.AddNetworkString("ixIsCCA")

    function FACTION:OnTransferred(character)
        if self.player then
            local ply = self.player
            net.Start("ixIsCCA")
            net.Send(ply)
            ply.ixSwitchedToCCA = true
        end
    end

    net.Receive("ixIsCCA", function()
        LocalPlayer().ixSwitchedToCCA = true
    end)
end

function FACTION:GetDefaultName(client)
    return "UNRANKED CP UNIT", true
end

function FACTION:OnCharacterCreated(client, char)
    if client:Team() == FACTION_CCA then
        char:SetData("MadeCPChar", true)
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