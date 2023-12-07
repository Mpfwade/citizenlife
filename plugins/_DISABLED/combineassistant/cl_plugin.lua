
local PLUGIN = PLUGIN

function PLUGIN:PlayerCLSay(message)
	net.Start("ixCAPlayerSay")
		net.WriteString(message)
	net.SendToServer()
end

concommand.Add("+CombineAssistant", function()
	local client = LocalPlayer()
	if (!client:IsCombine()) then return end

	local menu = DermaMenu()
	local area = client.ixArea
	local automaticActions = ix.option.Get("caAutomaticActionsEnabled")
	local CTO = ix.plugin.Get("cto")
	local squad = ix.plugin.Get("squad")
	local areas = ix.area and ix.area.stored or {}

	menu:AddOption((automaticActions and "Disable" or "Enable") .. " Automatic Actions", function()
		ix.option.Set("caAutomaticActionsEnabled", !automaticActions)
	end):SetIcon(automaticActions and "icon16/flag_red.png" or "icon16/flag_green.png")

	menu:AddSpacer()

	local radioChild, radioParent = menu:AddSubMenu("Radio")
	radioParent:SetIcon("icon16/transmit_blue.png")
		radioChild:AddOption("Reply: Affirmative", function()
			PLUGIN:PlayerCLSay("/radio " .. ix.option.Get("caRadioReplyAffirmative"))
		end):SetIcon("icon16/tick.png")
		radioChild:AddOption("Reply: Negative", function()
			PLUGIN:PlayerCLSay("/radio " .. ix.option.Get("caRadioReplyNegative"))
		end):SetIcon("icon16/cross.png")
		radioChild:AddOption("Report: Location", function()
			if (area == "") then return end
			PLUGIN:PlayerCLSay("/radio " .. string.format(ix.option.Get("caRadioReportArea"), area))
		end):SetIcon("icon16/image.png")
		radioChild:AddOption("Report: Citizen Count", function()
			if (area == "") then return end
			local count = 0

			for _, entity in ipairs(ents.FindInBox(ix.area.stored[area].startPosition, ix.area.stored[area].endPosition)) do
				if (!entity:IsPlayer()) then continue end
				if (entity:IsCombine()) then continue end
				
				count = count + 1
			end

			PLUGIN:PlayerCLSay("/radio " .. string.format(ix.option.Get("caRadioReportCivCount"), count))
		end):SetIcon("icon16/group.png")

		radioChild:AddSpacer()
		local backupChild, backupParent = radioChild:AddSubMenu("Request Backup")
		backupParent:SetIcon("icon16/exclamation.png")
			backupChild:AddOption("Code 1 (Respond at Will)", function()
				PLUGIN:PlayerCLSay("/radio Requesting additionals" .. (((area and area != "") and " at " .. area) or "") .. ", Code 1.")
			end)
			backupChild:AddOption("Code 2 (Urgent Response)", function()
				PLUGIN:PlayerCLSay("/code2")
			end)
			backupChild:AddOption("Code 3 (Emergency Response)", function()
				PLUGIN:PlayerCLSay("/code3")
			end)

	local dispatchChild, dispatchParent = menu:AddSubMenu("Dispatch")
	dispatchParent:SetIcon("icon16/feed.png")
		local broadcastChild, broadcastParent = dispatchChild:AddSubMenu("Broadcast")
		broadcastParent:SetIcon("icon16/feed.png")
			for command, _ in pairs(Schema.voices.stored.dispatch) do
				broadcastChild:AddOption(string.upper(command), function()
					if (!client:IsDispatch()) then client:Notify("You cannot not broadcast!") return end
					PLUGIN:PlayerCLSay("/dispatch " .. command)
				end)
			end

		local dispRadioChild, dispRadioParent = dispatchChild:AddSubMenu("Radio")
		dispRadioParent:SetIcon("icon16/transmit.png")
			dispRadioChild:AddOption("Reminder: PT Forming", function()
				if (!client:IsDispatch()) then client:Notify("You are not Dispatch!") return end
				PLUGIN:PlayerCLSay("/radio Protection Functionaries, reminder: Formation of Protection Teams enhances preservation of local Socio-Politi Stabilization Index.")
			end)
			dispRadioChild:AddOption("Reminder: Radio Cohesion", function()
				if (!client:IsDispatch()) then client:Notify("You are not Dispatch!") return end
				PLUGIN:PlayerCLSay("/radio Reminder, Protection Functionaries: Cohesive usage of TAC coupled with status reports on regular intervals are key to preserving Stable Socio-Stabilization Readout. Non-Cohesive or complete lack of TAC utilization on demand and/or regular intervals may forsee 99 charges and/or reduction of family cohesion status.")
			end)
			dispRadioChild:AddOption("Reminder: Behavior", function()
				if (!client:IsDispatch()) then client:Notify("You are not Dispatch!") return end
				PLUGIN:PlayerCLSay("/radio Protection Units, reminder: Non-Cohesive behavior can result in fracture of the local Socio-Politi Stabilization Index and is grounds for 99 charges and/or reduction of family cohesion status.")
			end)
			dispRadioChild:AddOption("CPT Status Request", function()
				if (!client:IsDispatch()) then client:Notify("You are not Dispatch!") return end
				PLUGIN:PlayerCLSay("/radio Local Civil-Protection Teams; report status.")
			end)

			if (areas and !table.IsEmpty(areas)) then
				local immediateLeaveChild, immediateLeaveParent = dispRadioChild:AddSubMenu("Leave Area Immediately")
				for area, _ in pairs(areas) do
					immediateLeaveChild:AddOption(area, function()
						if (!client:IsDispatch()) then client:Notify("You are not Dispatch!") return end
						PLUGIN:PlayerCLSay("/radio Attention, Protection Teams. Assimilate immediate disengagement procedures from internal " .. area .. " perimeters.")
					end)
				end

				local taskLeaveChild, taskLeaveParent = dispRadioChild:AddSubMenu("Leave Area upon Task Completion")
				for area, _ in pairs(areas) do
					taskLeaveChild:AddOption(area, function()
						if (!client:IsDispatch()) then client:Notify("You are not Dispatch!") return end
						PLUGIN:PlayerCLSay("/radio Protection Teams, evacuate from " .. area .. " upon mature termination of assigned mandate.")
					end)
				end
			end
			
	local performChild, performParent = menu:AddSubMenu("Perform")
	performParent:SetIcon("icon16/script_go.png")

		performChild:AddOption("Search Instructions", function()
			PLUGIN:PlayerCLSay(ix.option.Get("caSearchInstructions"))
		end):SetIcon("icon16/comment.png")

	if (CTO) then
		menu:AddSpacer()
		
		local statusChild, statusParent = menu:AddSubMenu("Civil Status")
		statusParent:SetIcon("icon16/chart_bar.png")
		for status, _ in pairs(CTO.sociostatusColors) do
			statusChild:AddOption(status, function()
				PLUGIN:PlayerCLSay("/ChangeCityCode " .. status)
			end)
		end

		local cameraChild, cameraParent = menu:AddSubMenu("Cameras")
		cameraParent:SetIcon("icon16/camera_link.png")
		for _, camera in ipairs(ents.FindByClass("npc_combine_camera")) do
			local cameraID = camera:EntIndex()
			local child, parent = cameraChild:AddSubMenu("C-i" .. cameraID)
			parent:SetIcon("icon16/camera.png")
				child:AddOption("Enable", function()
					PLUGIN:PlayerCLSay("/CameraEnable " .. cameraID)
				end):SetIcon("icon16/camera_add.png")
				child:AddOption("Disable", function()
					PLUGIN:PlayerCLSay("/CameraDisable " .. cameraID)
				end):SetIcon("icon16/camera_delete.png")
		end
	end

	menu:Open(ScrW() / 2, ScrH() / 2)
end)

concommand.Add("-CombineAssistant", function() CloseDermaMenus() end)
