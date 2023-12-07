--[[ Base Config ]]--

FACTION.name = "Combine Artificial Intelligence"
FACTION.description = [[Name: CMB Dispatch
Description: The Combine Artificial Intelligence is almost certainly artificial in origin, the voice will usually issue warnings of resistance infiltration or instructions to nearby units in a distinctive flat, clinical tone. Her disjointed speech, similar to that of telephone banking systems, and ability to apparently broadcast to more than one location at once suggests that she is an artificially intelligent computer system.]]
FACTION.color = Color(150, 50, 50)

--[[ Helix Base Config ]]--

FACTION.models = {
	"models/Combine_Scanner.mdl",
}

FACTION.isGloballyRecognized = true
FACTION.isDefault = false

FACTION.payTime = 1000
FACTION.pay = 0

--[[ Custom Config ]]--

FACTION.defaultClass = nil
FACTION.adminOnly = true
FACTION.donatorOnly = false
FACTION.noModelSelection = false
FACTION.requiredXP = nil
FACTION.command = "ix_faction_become_dispatch"
FACTION.modelWhitelist = "models"

function ScannerCreate(client)
	local scanner = ix.plugin.list.scanner

	if (scanner) then
		scanner:createScanner(client)
		ix.ScannerActive = true
	else
		client:ChatPrint("The server is missing the 'scanner' plugin.")
	end
end

function FACTION:OnSpawn(client)
	ScannerCreate(client)
end

function FACTION:OnTransferred(client)
	ScannerCreate(client)
end

function FACTION:OnLeave(client)
	if (IsValid(client.ixScn)) then
		local data = {}
			data.start = client.ixScn:GetPos()
			data.endpos = data.start - Vector(0, 0, 1024)
			data.filter = {client, client.ixScn}
		local position = util.TraceLine(data).HitPos

		client.ixScn.spawn = position
		client.ixScn:Remove()
	end
end
--[[ Plugin Configs ]]--

FACTION.canSeeWaypoints = true
FACTION.canAddWaypoints = true
FACTION.canRemoveWaypoints = true
FACTION.canUpdateWaypoints = true

--[[ Do not change! ]]--

FACTION_DISPATCH = FACTION.index