--[[---------------------------------------------------------------------------
	** Copyright (c) 2021 Connor ---- (ZIKE)
	** This file is private and may not be shared, downloaded, used, sold or even copied.
---------------------------------------------------------------------------]]--

PLUGIN.name = "Extended Commands"
PLUGIN.author = "ZIKE"
PLUGIN.description = "A Plugin which creates ic commands through 1 lua file."
PLUGIN.license = "MIT License | Copyright (c) 2020 RiggsMackay"
local PLUGIN = PLUGIN

function PLUGIN:InitializedChatClasses()
	timer.Simple(0.1, function()
		ix.chat.Register("it", {
			OnChatAdd = function(self, speaker, text)
				chat.AddText(Color(100, 50, 50), text)
			end,
			CanHear = ix.config.Get("chatRange", 280) * 2,
			prefix = {"/It", "/Do"},
			description = "@cmdIt",
			indicator = "chatPerforming",
			deadCanChat = true
		})
	end)
end

ix.command.Add("Code3", {
    description = "Sends your location to all units for an urgent emergency",
    OnCheckAccess = function(_, ply) return ply:IsCombine() end,
    OnRun = function(_, ply, client)
        local location = ply:GetArea()
        local mplocation = ply:GetArea()
        local waypointPlugin = ix.plugin.Get("waypoints")
        if waypointPlugin then
            local waypoint = {
                pos = ply:GetPos(),
                text = "CODE 3",
                color = Color(255, 0, 0),
                addedBy = ply,
                time = CurTime() + 100
            }

            ply:SetNetVar("waypoint", #waypointPlugin.waypoints) -- Save the waypoint index for easy access later.
            waypointPlugin:AddWaypoint(waypoint)
        end

        if location == "" then
            location = "unknown location"
        end

        local locationSounds = {
            ["Sector-1"] = "npc/overwatch/radiovoice/sector.wav",
            ["Sector-2"] = "npc/overwatch/radiovoice/sector.wav",
            ["CWU Building"] = "npc/overwatch/radiovoice/productionblock.wav",
            ["Intake-Hub 1"] = "npc/overwatch/radiovoice/workforceintake.wav",
            ["Residential Block 1"] = "npc/overwatch/radiovoice/residentialblock.wav",
            ["404 Zone"] = "npc/overwatch/radiovoice/zone.wav",
        }
        local mplocationSound = locationSounds[mplocation] or "npc/overwatch/radiovoice/_comma.wav"

        local sounds = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/allteamsrespondcode3.wav", "npc/overwatch/radiovoice/officerat.wav", mplocationSound, "npc/overwatch/radiovoice/off2.wav"}

        for k, v in ipairs(player.GetAll()) do
            if v:IsCombine() then
                ix.util.EmitQueuedSounds(v, sounds, 1, 0.2, 150)
            end
        end

        ix.chat.Send(ply, "dispatchradio", "All teams respond, code 3. Location: " .. location .. ", requested by " .. ply:Nick(), false, nil)
        Schema:AddCombineDisplayMessage("All units, code 3.", Color(255, 0, 0), true, "music/destabilizing3.wav")
    end
})


ix.command.Add("Code2", {
    description = "Sends your location to all units for a non-urgent situation",
    OnCheckAccess = function(_, ply) return ply:IsCombine() end,
    OnRun = function(_, ply, client)
        local location = ply:GetArea()
		local waypointPlugin = ix.plugin.Get("waypoints")
        if waypointPlugin then
            local waypoint = {
                pos = ply:GetPos(),
                text = "CODE 2",
                color = Color(255, 251, 0),
                addedBy = ply,
                time = CurTime() + 65
            }

            ply:SetNetVar("waypoint", #waypointPlugin.waypoints) -- Save the waypoint index for easy access later.
            waypointPlugin:AddWaypoint(waypoint)
        end

        if location == "" then
            location = "unknown location"
        end

        local sounds = {"npc/metropolice/vo/allunitscode2.wav"}

        for k, v in ipairs(player.GetAll()) do
            if (v:IsCombine()) then
                ix.util.EmitQueuedSounds(v, sounds, 0, 0.2, 85)
            end
        end

        ix.chat.Send(ply, "radio", "All units code 2, at " .. location, nil)
        Schema:AddCombineDisplayMessage("All units, code 2.", Color(252, 252, 3), true, "music/destabilizing3.wav")
    end
})
do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		local character = client:GetCharacter()
		local phones = character:GetInventory():GetItemsByUniqueID("phone", true)
		local item

		for k, v in ipairs(phones) do
			if (v:GetData("enabled", false)) then
				item = v
				break
			end
		end

		if (item) then
			if (!client:IsRestricted()) then
				ix.chat.Send(client, "phone", message)
				ix.chat.Send(client, "phone_eavesdrop", message)
			else
				return "@notNow"
			end
		elseif (#phones > 0) then
			return "@phoneNotOn"
		else
			return "@phoneRequired"
		end
	end

	ix.command.Add("Phone", COMMAND)
end


do
	local COMMAND = {}
	COMMAND.arguments = ix.type.number

	function COMMAND:OnRun(client, frequency)
		local character = client:GetCharacter()
		local inventory = character:GetInventory()
		local itemTable = inventory:HasItem("phone")

		if (itemTable) then
			if (string.find(frequency, "^^%d%d%d%.%d%d%d$")) then
				character:SetNWBool("frequency", frequency)
				itemTable:SetNWBool("frequency", frequency)

				client:Notify(string.format("You have set your phone frequency to %s.", frequency))
			end
		end
	end

	ix.command.Add("SetFreq", COMMAND)
end