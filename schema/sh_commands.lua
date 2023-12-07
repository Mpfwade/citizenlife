--[[---------------------------------------------------------------------------
	Initializing Extra Command Classes
---------------------------------------------------------------------------]]
--
ix.command.Add("Tie", {
    description = "Tie someone in front of you.",
    OnCheckAccess = function(_, ply)
        return ply:IsCombine() or ply:IsRebel()
    end,
    OnRun = function(self, ply)
        local data = {}
        data.start = ply:GetShootPos()
        data.endpos = data.start + ply:GetAimVector() * 96
        data.filter = ply
        local trace = util.TraceLine(data)
        local target = trace.Entity
		local tieAnim = "Buttonfront"

        if IsValid(target) and ((target:IsPlayer() and target:GetCharacter()) or (IsValid(target.ixPlayer) and target.ixPlayer:GetCharacter())) then
            local targetEntity = target

            if IsValid(target.ixPlayer) then
                targetEntity = target.ixPlayer
            end

            if not targetEntity:GetNetVar("tying") and not targetEntity:IsRestricted() then
                ply:SetAction("You are tying " .. targetEntity:Nick(), 3)
				ply:ForceSequence(tieAnim, nil, 0.75, true)

                if IsValid(target.ixPlayer) then
					ply:EmitSound("misc/cablecuff.wav")

                    targetEntity:SetRestricted(true)
                    targetEntity:SetNetVar("tying")
                    targetEntity:NotifyLocalized("fTiedUp")

                    if targetEntity:IsCombine() then
                        local location = targetEntity:GetArea() or "unknown location"
                        Schema:AddCombineDisplayMessage("Downloading lost radio contact information...")
                        Schema:AddCombineDisplayMessage("WARNING! Radio contact lost for unit at " .. location .. "...", Color(255, 0, 0, 255), true)
                    end

                    ply:SetAction()
                    targetEntity:SetAction()
                else
                    -- Execute tying logic with DoStaredAction for regular player
                    ply:DoStaredAction(targetEntity, function()
						ply:EmitSound("misc/cablecuff.wav")

                        targetEntity:SetRestricted(true)
                        targetEntity:SetNetVar("tying")
                        targetEntity:NotifyLocalized("fTiedUp")

                        if targetEntity:IsCombine() then
                            local location = targetEntity:GetArea() or "unknown location"
                            Schema:AddCombineDisplayMessage("Downloading lost radio contact information...")
                            Schema:AddCombineDisplayMessage("WARNING! Radio contact lost for unit at " .. location .. "...", Color(255, 0, 0, 255), true)
                        end
                    end, 3, function()
                        ply:SetAction()
                        targetEntity:SetAction()
                        targetEntity:SetNetVar("tying")
						
                    end)
                end

                targetEntity:SetNetVar("tying", true)
                targetEntity:SetAction("You are being tied by " .. ply:Nick(), 3)
            else
                ply:NotifyLocalized("plyNotValid")
            end
        end
    end
})

	
	
ix.command.Add("DoorBuy", {
	description = "@cmdDoorBuy",
	OnRun = function(self, client, arguments)
		if client:Team() == FACTION_CCA then return end
		if client:Team() == FACTION_OTA then return end
		if client:Team() == FACTION_VORTIGAUNT then return end

		-- Get the entity 96 units infront of the player.
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local trace = util.TraceLine(data)
		local entity = trace.Entity

		-- Check if the entity is a valid door.
		if (IsValid(entity) and entity:IsDoor() and !entity:GetNetVar("disabled")) then
			if (!entity:GetNetVar("ownable") or entity:GetNetVar("faction") or entity:GetNetVar("class")) then
				return "@dNotAllowedToOwn"
			end

			if (IsValid(entity:GetDTEntity(0))) then
				return "@dOwnedBy", entity:GetDTEntity(0):Name()
			end

			entity = IsValid(entity.ixParent) and entity.ixParent or entity

			-- Get the price that the door is bought for.
			local price = entity:GetNetVar("price", ix.config.Get("doorCost"))
			local character = client:GetCharacter()

			-- Check if the player can actually afford it.
			if (character:HasMoney(price)) then
				-- Set the door to be owned by this player.
				entity:SetDTEntity(0, client)
				entity.ixAccess = {
					[client] = DOOR_OWNER
				}

				Schema:CallOnDoorChildren(entity, function(child)
					child:SetDTEntity(0, client)
				end)

				local doors = character:GetVar("doors") or {}
					doors[#doors + 1] = entity
				character:SetVar("doors", doors, true)

				-- Take their money and notify them.
				character:TakeMoney(price)
				hook.Run("OnPlayerPurchaseDoor", client, entity, true, Schema.CallOnDoorChildren)

				ix.log.Add(client, "buydoor")
				return "@dPurchased", ix.currency.Get(price)
			else
				-- Otherwise tell them they can not.
				return "@canNotAfford"
			end
		else
			-- Tell the player the door isn't valid.
			return "@dNotValid"
		end
	end
})

ix.command.Add("Kickdoor", {
	description = "Attempt to kick a door open.",
	OnRun = function(self, client, ply)
		if client:Team() == FACTION_OTA or client:Team() == FACTION_CCA then
			local see = client:GetEyeTraceNoCursor()
			if see.Entity:GetClass() =="prop_door_rotating" then
				if client:Team() == FACTION_CCA then -- beginning of MPF injection
					local inject = Sound("npc/metropolice/vo/inject.wav")
					local function doorOpen()
						client:ForceSequence("kickdoorbaton")
						timer.Simple(1.1, function()
							see.Entity:Fire("Unlock")
							see.Entity:EmitSound("physics/wood/wood_plank_break1.wav", 100, 90)
							see.Entity:Fire("Open")
							client:Notify("You successfully kicked the door open!")
						end)
					end
					client:EmitSound(inject)
					timer.Simple(SoundDuration(inject), doorOpen) -- end of MPF injection
				elseif client:Team() == FACTION_OTA then -- beginning of OTA injection
						client:ForceSequence("range_fistse_noga_1")
						timer.Simple(0.4, function()
							see.Entity:Fire("Unlock")
							see.Entity:EmitSound("physics/wood/wood_plank_break1.wav", 100, 90)
							see.Entity:Fire("Open")
							client:Notify("You successfully kicked the door open!")
						end) -- end of OTA injection
				else
					see.Entity:Fire("Unlock")
					see.Entity:Fire("Open")
					client:Notify("You successfully kicked the door open!")
					see.Entity:EmitSound("physics/wood/wood_plank_break1.wav", 100, 90)
				end
			else
				client:Notify("This is not a valid door!")
			end
				end
			end
})


ix.command.Add("ForceRespawn", {
	description = "Forcefully respawn yourself.",
	OnRun = function(_, ply)
		if not (ply:IsAdmin()) then
			return "You do not have access to this command!"
		end
		ply:Spawn()
		if ply.deathPos and ply.deathAngles then
			ply:SetPos(ply.deathPos)
			ply:SetAngles(ply.deathAngles)
		end
	end
})

ix.command.Add("Discord", {
	description = "Join our Discord Server!",
	OnRun = function(_, ply)
		ply:SendLua([[gui.OpenURL("https://discord.gg/mbkNfHBJxF")]])
	end
})

ix.command.Add("Content", {
	description = "Get our Server's Content Pack.",
	OnRun = function(_, ply)
		ply:SendLua([[gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2809634739")]])
	end
})

ix.command.Add("CharFallOver", {
	description = "@cmdCharFallOver",
	arguments = bit.bor(ix.type.number, ix.type.optional),
	OnRun = function(self, ply, time)
		if ply:IsAdmin() then
			ply:Notify("Your character fell over, do not abuse it.")
		else
            ply:Notify("You need to be a staff member to fall over!")
			return false
		end

		if (!ply:Alive() or ply:GetMoveType() == MOVETYPE_NOCLIP) then
			return "@notNow"
		end

		if (time and time > 0) then
			time = math.Clamp(time, 1, 60)
		end

		if (!IsValid(ply.ixRagdoll)) then
			ply:SetRagdolled(true, time)
		end
	end
})

ix.command.Add("SetModel", {
	description = "Set your model as a staff member.",
	arguments = ix.type.string,
	OnRun = function(_, ply, chosenModel)
		if not ply:IsAdmin() then
			return "You need to be a staff member to change your model!"
		end

		ply:SetModel(tostring(chosenModel))
	end
})

ix.command.Add("Search", {
    description = "Search the person tied infront of you.",
    OnRun = function(self, client)
        local data = {}
        data.start = client:GetShootPos()
        data.endpos = data.start + client:GetAimVector() * 96
        data.filter = client
        local target = util.TraceLine(data).Entity
        local searchAnim = "Spreadwall"

		if not IsValid(target) or not target:IsPlayer() or not target:IsRestricted() then
            return "You must be looking at a tied character before searching them!"
        end
            if not client:IsRestricted() then
				ix.chat.Send(client, "me", "searches the person infront of them thoroughly.")
                client:ForceSequence(searchAnim, nil, 6, true)
                client:EmitSound("sniper/foley.wav")
                Schema:SearchPlayer(client, target)
            else
                return "@notNow"
            end
        end
})

ix.command.Add("ToggleSecondZoneGate", {
	description = "Opens the 404 Zone Sector 2 combine gate.",
	OnRun = function(_, ply)
		if not (ply:IsCombineCommand() or ply:IsAdmin()) then
			ply:Notify("You need to be a higher ranking to open the gate.")
			return false
		end

		for k, v in pairs(ents.FindByName("zone2_404zone_gate_1")) do
			if ( !v.Opened ) then
				Schema:AddCombineDisplayMessage("Attention Sector 2 404 Zone Gate has been opened", Color(255, 0, 0), true)
				v:Fire("SetAnimation", "open")
				v:EmitSound("ambient/machines/wall_move1.wav", 90)

				v:EmitSound("LiteNetwork/hl2rp/cityvoice/unknown_alarm.ogg", 80)
				timer.Simple(4, function()
					v:EmitSound("LiteNetwork/hl2rp/cityvoice/unknown_alarm.ogg", 80)
				end)

				v.Opened = true

				timer.Simple(2.5, function()
					v:EmitSound("plats/hall_elev_stop.wav", 90)
				end)
			else
				Schema:AddCombineDisplayMessage("Attention Sector 2 404 Zone Gate has been closed", Color(255, 0, 0), true)
				v:Fire("SetAnimation", "close")
				v:EmitSound("ambient/machines/wall_move2.wav", 90)

				v:EmitSound("LiteNetwork/hl2rp/cityvoice/unknown_alarm.ogg", 80)
				timer.Simple(4, function()
					v:EmitSound("LiteNetwork/hl2rp/cityvoice/unknown_alarm.ogg", 80)
				end)

				v.Opened = false

				timer.Simple(5, function()
					v:EmitSound("plats/tram_hit4.wav", 90)
				end)
			end
		end
	end
})

ix.command.Add("ToggleAPCGate", {
	description = "Opens the APC Garage combine gate.",
	OnRun = function(_, ply)
		if not ((ply:Nick():find("GRID") or ply:Nick():find("OTA") or ply:IsAdmin()) or (ply:IsCombineCommand() or ply:IsAdmin())) then
			ply:Notify("You need to be a higher ranking to open the gate.")
			return false
		end

		for k, v in pairs(ents.FindByName("zone_2_apcgarage_gate_1")) do
			if ( !v.Opened ) then
				Schema:AddCombineDisplayMessage("Attention APC Garage Gate has been opened", Color(255, 0, 0), true)
				v:Fire("SetAnimation", "open")
				v:EmitSound("ambient/machines/wall_move1.wav", 90)

				v:EmitSound("LiteNetwork/hl2rp/cityvoice/unknown_alarm.ogg", 80)
				timer.Simple(4, function()
					v:EmitSound("LiteNetwork/hl2rp/cityvoice/unknown_alarm.ogg", 80)
				end)

				v.Opened = true

				timer.Simple(2.5, function()
					v:EmitSound("plats/hall_elev_stop.wav", 90)
				end)
			else
				Schema:AddCombineDisplayMessage("Attention APC Garage Gate has been closed", Color(255, 0, 0), true)
				v:Fire("SetAnimation", "close")
				v:EmitSound("ambient/machines/wall_move2.wav", 90)

				v:EmitSound("LiteNetwork/hl2rp/cityvoice/unknown_alarm.ogg", 80)
				timer.Simple(4, function()
					v:EmitSound("LiteNetwork/hl2rp/cityvoice/unknown_alarm.ogg", 80)

					timer.Simple(4, function()
						v:EmitSound("LiteNetwork/hl2rp/cityvoice/unknown_alarm.ogg", 80)
					end)
				end)

				v.Opened = false

				timer.Simple(5, function()
					v:EmitSound("plats/tram_hit4.wav", 90)
				end)
			end
		end
	end
})

ix.command.Add("FixLegs", {
	description = "Fixes broken legs.",
	adminOnly = true,
	arguments = {bit.bor(ix.type.character, ix.type.optional)},
	OnRun = function(_, ply, target)
		if not (ply:IsAdmin()) then
			ply:Notify("You need to be a staff member in order to use this command.")
			return false
		end
		local char = ply:GetCharacter()

		if target then
			ply:Notify("Your legs have been healed, by a staff member.")
			target:SetData("brokenLegs", false)
		else
			ply:Notify("Your legs have been healed.")
			char:SetData("brokenLegs", false)
		end
	end
})

properties.Add("ixGetSteamID", {
	MenuLabel = "Copy SteamID",
	Order = 999,
	MenuIcon = "icon16/user_add.png",

	Filter = function(self, ent, ply)
		if ( !IsValid( ent ) ) then return false end
		if not ( ent:IsPlayer() ) then return false end
		if not ( ply:IsAdmin() ) then return false end

		return true
	end,
	Action = function(self, ent)
		SetClipboardText(ent:IsBot() and ent:EntIndex() or ent:SteamID())
	end
})

properties.Add("ixShowProfile", {
	MenuLabel = "Show Profile",
	Order = 999,
	MenuIcon = "icon16/user_add.png",

	Filter = function(self, ent, ply)
		if ( !IsValid( ent ) ) then return false end
		if not ( ent:IsPlayer() ) then return false end
		if not ( ply:IsAdmin() ) then return false end

		return true
	end,
	Action = function(self, ent)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	Receive = function(self, length, ply)
		local target = net.ReadEntity()

		target:ShowProfile()
	end
})

properties.Add("ixOpenInventory", {
	MenuLabel = "Open Inventory",
	Order = 999,
	MenuIcon = "icon16/box.png",

	Filter = function(self, ent, ply)
		if ( !IsValid( ent ) ) then return false end
		if not ( ent:IsPlayer() ) then return false end
		if not ( ply:IsAdmin() ) then return false end

		return true
	end,
	Action = function(self, ent)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	Receive = function(self, length, ply)
		local target = net.ReadEntity()

		Schema:SearchPlayer(ply, target)
	end
})

properties.Add("ixFixLegs", {
	MenuLabel = "Fix Legs",
	Order = 999,
	MenuIcon = "icon16/user.png",

	Filter = function(self, ent, ply)
		if ( !IsValid( ent ) ) then return false end
		if not ( ent:IsPlayer() and ent:GetCharacter() ) then return false end
		if not ( ply:IsAdmin() ) then return false end
		if not ( ply:GetCharacter():GetData("ixBrokenLegs") ) then return false end

		return true
	end,
	Action = function(self, ent)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	Receive = function(self, length, ply)
		local target = net.ReadEntity()

		ply:GetCharacter():SetData("ixBrokenLegs", true)
	end
})

properties.Add("ixFreezePlayer", {
	MenuLabel = "Freeze / UnFreeze Player",
	Order = 999,
	MenuIcon = "icon16/user_add.png",

	Filter = function(self, ent, ply)
		if ( !IsValid( ent ) ) then return false end
		if not ( ent:IsPlayer() ) then return false end
		if not ( ply:IsAdmin() ) then return false end

		return true
	end,
	Action = function(self, ent)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	Receive = function(self, length, ply)
		local target = net.ReadEntity()

		if ( target.ixFrozen ) then
			target:Freeze(false)
			target.ixFrozen = nil
		else
			target.ixFrozen = true
			target:Freeze(true)
		end
	end
})

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.character

	function COMMAND:OnRun(client, target)
		local targetClient = target:GetPlayer()

		if (!hook.Run("CanPlayerViewData", client, targetClient)) then
			return "@cantViewData"
		end

		netstream.Start(client, "ViewData", targetClient, target:GetData("cid") or false, target:GetData("combineData"))
	end

	ix.command.Add("ViewData", COMMAND)
end

do
	local COMMAND = {}

	function COMMAND:OnRun(client, arguments)
		if (!hook.Run("CanPlayerViewObjectives", client)) then
			return "@noPerm"
		end

		netstream.Start(client, "ViewObjectives", Schema.CombineObjectives)
	end

	ix.command.Add("ViewObjectives", COMMAND)
end
