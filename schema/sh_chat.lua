--[[---------------------------------------------------------------------------
	Initializing Extra Chat Classes
---------------------------------------------------------------------------]]--

ix.chat.Register("broadcast", {
	CanSay = function(self, speaker, text)
		if not (speaker:IsCombineCommand() or speaker:IsCA()) then
			speaker:Notify("Only the city Administrator can broadcast stuff!")
			return false
		end
	end,
	OnChatAdd = function(self, speaker, text)
		chat.AddText(Material("willardnetworks/chat/broadcast_icon.png"), Color(150, 0, 0), '[CITY-BROADCAST] '..speaker:Nick()..' broadcasts ', ix.config.Get("chatColor"), '"'..text..'"')
	end,
	CanHear = function(self, speaker, listener)
		PlayEventSound("ambient/alarms/warningbell1.wav")
		return true
	end,
	prefix = {"/Broadcast", "/BR"},
	description = "Broadcast something to the city (Will play a warning alarm when a boradcast is sent).",
	indicator = "chatPerforming",
	font = "BroadcastFont",
	deadCanChat = false
})

ix.chat.Register("radio", {
	CanSay = function(self, speaker, text)
		if not (speaker:IsCombine() or speaker:IsCA()) then
			speaker:Notify("Only the Combine can radio stuff!")
			return false
		end
	end,
	OnChatAdd = function(self, speaker, text)
		if ( speaker ) then
			chat.AddText(Material("willardnetworks/chat/cmb_shared_icon.png"), Color(0,138,216), speaker:Nick().." radios in " ..text.. " [TAC-3]")
		end
	end,
	CanHear = function(self, speaker, listener)
		if not (listener:IsCombine() or listener:IsCA() or listener:IsDispatch()) then
			return false
		else 
			return true
		end
	end,
	prefix = {"/Radio", "/R"},
	description = "Radio something to the combine.",
	indicator = "chatPerforming",
	font = "RadioFont",
	deadCanChat = false
})

ix.chat.Register("ptradio", {
    CanSay = function(self, speaker, text)
        if not (speaker:IsCombine() and speaker:GetSquad()) then
            speaker:Notify("You need to be in a patrol team as a combine to use this!")
            return false
        end
    end,
    OnChatAdd = function(self, speaker, text)
        if speaker then
            chat.AddText(Material("willardnetworks/chat/cmb_shared_icon.png"), Color(147, 112, 219), speaker:Nick() .. " radios in " .. text .. " [" .. speaker:GetNetVar("squad", "N/A") .. "]")
        end
    end,
    CanHear = function(self, speaker, listener)
        if not (listener:IsCombine() and listener:GetNetVar("squad")) or listener:IsDispatch() then
            return false
        else
            if listener:GetNetVar("squad") ~= speaker:GetNetVar("squad") then
                return false
            end
            return true
        end
    end,
    prefix = { "/PTRadio", "/PTR", "/PT" },
    description = "Radio something to your patrol team.",
    indicator = "chatPerforming",
    font = "RadioFont",
    deadCanChat = false
})


ix.chat.Register("importantradio", {
	CanSay = function(self, speaker, text)
		if not (speaker:IsCombineCommand() or speaker:IsCombineLeader()) then
			speaker:Notify("Only the Combine can radio stuff!")
			return false
		end
	end,
	OnChatAdd = function(self, speaker, text)
		if ( speaker ) then
			chat.AddText(Material("willardnetworks/chat/dispatch_icon.png"), Color(250, 20, 20), speaker:Nick().." [SENDS A COMMAND MESSAGE]: ", text)
		end
	end,
	CanHear = function(self, speaker, listener)
		if not (listener:IsCombine() or listener:IsCA() or listener:IsDispatch()) then
			return false
		else

			listener:EmitSound("buttons/combine_button_locked.wav", 40, math.random(90,110))
			return true
		end
	end,
	prefix = {"/IRadio", "/IR"},
	description = "Radio something important to the combine.",
	indicator = "chatPerforming",
	font = "RadioFont",
	deadCanChat = false
})

ix.chat.Register("commandradio", {
	CanSay = function(self, speaker, text)
		if not (speaker:IsCombineCommand() or speaker:IsCombineLeader()) then
			speaker:Notify("Only the High Command Combine can radio stuff!")
			return false
		end
	end,
	OnChatAdd = function(self, speaker, text)
		if ( speaker ) then
			chat.AddText(Material("willardnetworks/chat/dispatch_icon.png"), Color(250, 20, 20), speaker:Nick().." radios in command freq. [" ..text.. "]")
		end
	end,
	CanHear = function(self, speaker, listener)
		if not listener:IsCombineCommand() then
			return false
		else

			return true
		end
	end,
	prefix = {"/CMDRadio", "/CR"},
	description = "Radio something to the commanding units of the combine.",
	indicator = "chatPerforming",
	font = "RadioFont",
	deadCanChat = false
})

ix.chat.Register("dispatchradio", {
	CanSay = function(self, speaker, text)
		if not (speaker:IsAdmin() or speaker:IsDispatch() or speaker:IsGamemaster()) then
			speaker:Notify("Only Dispatch can radio important stuff!")
			return false
		end
	end,
	OnChatAdd = function(self, speaker, text)
		if ( speaker ) then
			chat.AddText(Material("willardnetworks/chat/dispatch_icon.png"), Color(200, 50, 50), "Dispatch radios in ", text)
		end
	end,
	CanHear = function(self, speaker, listener)
		if not (listener:IsCombine() or listener:IsCA() or listener:IsDispatch()) then
			return false
		else
			return true
		end
	end,
	prefix = {"/DRadio", "/DR"},
	description = "Radio something to the combine.",
	indicator = "chatPerforming",
	font = "RadioFont",
	deadCanChat = false
})

ix.chat.Register("dispatch", {
	CanSay = function(self, speaker, text)
		if not (speaker:IsDispatch() or speaker:IsAdmin() or speaker:IsCombineCommand()) then
			speaker:Notify("Only Dispatch can announce on the loud speakers.")
			return false
		end
	end,
	OnChatAdd = function(self, speaker, text)
		if ( speaker ) then
			chat.AddText(Color(189,183,107), "A voice announces on the loudspeaker, ", string.format('"%s"', text))
		end
	end,
	CanHear = function(self, speaker, listener)
		return true
	end,
	prefix = {"/Dispatch", "/D"},
	description = "Dispatch something to the city.",
	indicator = "chatPerforming",
	font = "RadioFont",
	deadCanChat = false
})

ix.chat.Register("dispatchradioforce", {
	OnChatAdd = function(self, speaker, text)
		if ( speaker ) then
			chat.AddText(Material("willardnetworks/chat/dispatch_icon.png"), Color(200, 50, 50), "Dispatch radios in <:: "..text.." ::>")
		end
	end,
	CanHear = function(self, speaker, listener)
		if not (listener:IsCombine() or listener:IsCA() or listener:IsDispatch()) then
			return false
		else
			return true
		end
	end,
	font = "RadioFont",
	deadCanChat = true,
})

ix.chat.Register("dispatchperson", {
	OnChatAdd = function(self, speaker, text)
		if ( speaker ) then
			chat.AddText(Material("willardnetworks/chat/ca_radio_icon.png"), Color(81, 88, 146), "Dispatch radios from "..speaker:Nick().." radio: "..text)
		end
	end,
	CanHear = ix.config.Get("chatRange", 280),
	font = "RadioFont",
})

--[[---------------------------------------------------------------------------
	Initializing Original Chat Classes
---------------------------------------------------------------------------]]--

function Schema:InitializedChatClasses()
	ix.chat.Register("ic", {
		format = " \"%s\"",
		indicator = "chatTalking",
		font = "ixCustomChatFont",
		GetColor = function(self, speaker, text)
			if (LocalPlayer():GetEyeTrace().Entity == speaker) then
				return ix.config.Get("chatListenColor")
			end

			return ix.config.Get("chatColor")
		end,
		OnChatAdd = function(self, speaker, text, anonymous, info)
			local color = self:GetColor(speaker, text, info)
			local name = anonymous and L"someone" or hook.Run("GetCharacterName", speaker, "ic") or (IsValid(speaker) and speaker:Name() or "Console")

			if (speaker.ixBandanaEquipped) then
				name = "Masked Person"
			end

			if (speaker.ixGasmaskEquipped) then
				name = "Masked Person"
			end


			-- to you - inspired by willard networks
			local lookingAt = speaker:GetEyeTraceNoCursor().Entity == LocalPlayer()

			chat.AddText(team.GetColor(speaker:Team()), name, color, " says", lookingAt and " to you" or "", string.format(self.format, text))
		end,
		CanHear = ix.config.Get("chatRange", 280)
	})


	ix.chat.Register("w", {
		format = " \"%s\"",
		indicator = "chatWhispering",
		font = "ixCustomWhisperChatFont",
		description = "@cmdW",
		prefix = {"/W", "/Whisper"},
		OnChatAdd = function(self, speaker, text, anonymous, info)
			local color = Color(0, 150, 255)
			local name = anonymous and L"someone" or hook.Run("GetCharacterName", speaker, "w") or (IsValid(speaker) and speaker:Name() or "Console")

			if ( speaker.ixBandanaEquipped ) then
				name = "Masked Person"
			end

			if ( speaker.ixGasmaskEquipped ) then
				name = "Masked Person"
			end

			-- to you - inspired by willard networks
			local lookingAt = speaker:GetEyeTraceNoCursor().Entity == LocalPlayer()

			chat.AddText(Material("willardnetworks/chat/whisper_icon.png"), team.GetColor(speaker:Team()), name, color, " whispers", lookingAt and " to you" or "", string.format(self.format, text))
		end,
		CanHear = ix.config.Get("chatRange", 280) * 0.5
	})

	-- Yelling out loud.
	ix.chat.Register("y", {
		format = " \"%s\"",
		indicator = "chatYelling",
		font = "ixCustomYellChatFont",
		description = "@cmdY",
		prefix = {"/Y", "/Yell"},
		OnChatAdd = function(self, speaker, text, anonymous, info)
			local color = Color(250, 100, 0)
			local name = anonymous and L"someone" or hook.Run("GetCharacterName", speaker, "y") or (IsValid(speaker) and speaker:Name() or "Console")
			
			if ( speaker.ixBandanaEquipped ) then
				name = "Masked Person"
			end

			if ( speaker.ixGasmaskEquipped ) then
				name = "Masked Person"
			end

			-- to you - inspired by willard networks
			local lookingAt = speaker:GetEyeTraceNoCursor().Entity == LocalPlayer()

			chat.AddText(Material("willardnetworks/chat/yell_icon.png"), team.GetColor(speaker:Team()), name, color, " yells", lookingAt and " at you" or "", string.format(self.format, text))
		end,
		CanHear = ix.config.Get("chatRange", 280) * 2
	})

	ix.chat.Register("me", {
		format = "** %s %s",
		indicator = "chatPerforming",
		deadCanChat = true,
		font = "ixCustomChatFont",
		description = "@cmdMe",
		prefix = {"/Me", "/Action"},
		OnChatAdd = function(self, speaker, text, anonymous, info)
			local color = Color(251, 255, 0)
			local name = anonymous and L"someone" or hook.Run("GetCharacterName", speaker, "me") or (IsValid(speaker) and speaker:Name() or "Console")
			
			if ( speaker.ixBandanaEquipped ) then
				name = "Masked Person"
			end
			
			if ( speaker.ixGasmaskEquipped ) then
				name = "Masked Person"
			end

			chat.AddText(Material("willardnetworks/hud/stamina.png"), color, string.format(self.format, name, text))
		end,
		CanHear = ix.config.Get("chatRange", 280) * 2
	})

	-- Out of char.
	ix.chat.Register("ooc", {
		CanSay = function(self, speaker, text)
			if (!ix.config.Get("allowGlobalOOC")) then
				speaker:NotifyLocalized("Global OOC is disabled on this server.")
				return false
			else
				local delay = ix.config.Get("oocDelay", 10)

				-- Only need to check the time if they have spoken in OOC chat before.
				if (delay > 0 and speaker.ixLastOOC) then
					local lastOOC = CurTime() - speaker.ixLastOOC

					-- Use this method of checking time in case the oocDelay config changes.
					if (lastOOC <= delay and !CAMI.PlayerHasAccess(speaker, "Helix - Bypass OOC Timer", nil)) then
						speaker:NotifyLocalized("oocDelay", delay - math.ceil(lastOOC))

						return false
					end
				end

				-- Save the last time they spoke in OOC.
				speaker.ixLastOOC = CurTime()
			end
		end,
		OnChatAdd = function(self, speaker, text)
			-- @todo remove and fix actual cause of speaker being nil
			if (!IsValid(speaker)) then
				return
			end

			local icon = "icon16/user.png"
			local label = "Member"
			local color = Color(240, 240, 240)
			
			if (speaker:IsSuperAdmin()) then -- Super Admins
				icon = "icon16/ruby.png"
				label = "Higher Management"
				color = Color(230, 20, 20)
			elseif (speaker:IsAdmin()) then -- Admins
				icon = "icon16/shield_add.png"
				label = "Moderator"
				color = Color(25, 83, 219)
			elseif (speaker:IsDonator()) then -- Donators
				icon = "icon16/coins.png"
				label = "Donator"
				color = Color(200, 170, 0)
			end

			icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)

			chat.AddText(icon, Color(175, 0, 0), "[OOC] ", color, speaker:SteamName(), color_white, ": "..text)
		end,
		prefix = {"//", "/OOC"},
		description = "@cmdOOC",
		noSpaceAfter = true
	})

	-- Local out of char.
	ix.chat.Register("looc", {
		CanSay = function(self, speaker, text)
			local delay = ix.config.Get("loocDelay", 0)

			-- Only need to check the time if they have spoken in LOOC chat before.
			if (delay > 0 and speaker.ixLastLOOC) then
				local lastLOOC = CurTime() - speaker.ixLastLOOC

				-- Use this method of checking time in case the oocDelay config changes.
				if (lastLOOC <= delay and !CAMI.PlayerHasAccess(speaker, "Helix - Bypass OOC Timer", nil)) then
					speaker:NotifyLocalized("loocDelay", delay - math.ceil(lastLOOC))

					return false
				end
			end

			-- Save the last time they spoke in LOOC.
			speaker.ixLastLOOC = CurTime()
		end,
		OnChatAdd = function(self, speaker, text)
			-- @todo remove and fix actual cause of speaker being nil
			if (!IsValid(speaker)) then
				return
			end

			local icon = "icon16/user.png"
			local label = "Member"
			local color = Color(240, 240, 240)
			
			if (speaker:IsSuperAdmin()) then -- Super Admins
				icon = "icon16/ruby.png"
				label = "Higher Management"
				color = Color(230, 20, 20)
			elseif (speaker:IsAdmin()) then -- Admins
				icon = "icon16/shield_add.png"
				label = "Moderator"
				color = Color(25, 83, 219)
			elseif (speaker:IsDonator()) then -- Donators
				icon = "icon16/coins.png"
				label = "Donator"
				color = Color(200, 170, 0)
			end

			icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)

			local name = speaker:Nick()
			if ( speaker.ixBandanaEquipped ) then
				name = "Masked Person ["..speaker:Nick().."]"
			end

			chat.AddText(icon, Color(175, 0, 0), "[LOOC] ", color, speaker:SteamName(), team.GetColor(speaker:Team()), " ("..name..")", color_white, ": "..text)
		end,
		CanHear = ix.config.Get("chatRange", 280),
		prefix = {".//", "[[", "/LOOC"},
		description = "@cmdLOOC",
		noSpaceAfter = true
	})
end