--[[---------------------------------------------------------------------------
	Serverside Hooks
---------------------------------------------------------------------------]]
--
function Schema:LoadData()
    self:LoadCombineLocks()
    self:LoadForceFields()
end

function Schema:SaveData()
    self:SaveCombineLocks()
    self:SaveForceFields()
end

function Schema:OnReloaded()
    if (ix.luaReloaded or 0) < CurTime() then
        for k, v in pairs(player.GetAll()) do
            v:ChatNotify("Lua has been refreshed!")
            v:PlaySound("hl1/ambience/particle_suck1.wav")
        end

        ix.luaReloaded = CurTime() + 30
    end
end

function Schema:PlayerConnect(name, ip)
    for k, v in pairs(player.GetAll()) do
        v:PlaySound("garrysmod/content_downloaded.wav")
        v:ChatNotify(tostring(name) .. " is joining the Server!")
    end

    print(tostring(name) .. " is joining the Server! - [" .. tostring(ip) .. "]")
end

local pickupAbleEntities = {
    ["grenade_helicopter"] = true,
    ["npc_grenade_frag"] = true,
    ["npc_handgrenade"] = true,
    ["ww2_radio"] = true,
    ["ent_intercom_speaker"] = true
}

function Schema:CanPlayerHoldObject(ply, ent)
    if pickupAbleEntities[ent:GetClass()] then return true end
end

function Schema:PlayerSwitchFlashlight(ply, state)
    if (ply.ixAntiSpamFlashlight or 0) < CurTime() then
        ply.ixAntiSpamFlashlight = CurTime() + 0.2

        return true
    else
        return false
    end
end

function Schema:PlayerSpawnSENT(ply, class)
    if (class:find("ix_") and not class == "ix_radio") and not ply:IsSuperAdmin() then
        ply:Notify("Spawning Helix Entities has been disabled.")

        return false
    end
end

function Schema:OnCharacterCreated(ply, char)
    char:SetData("ixKnownName", char:GetName())
    char:SetData("ixPreferedModel", char:GetModel())
    print(ply:SteamName(), " [", ply:Nick(), "] - ", ply:SteamID(), " | OnCharacterCreated")
end

function Schema:PlayerFootstep(ply, pos, foot, sound, volume)
    local newSound = sound

    if ply:Team() == FACTION_CCA then
        newSound = "npc/metropolice/gear" .. math.random(1, 6) .. ".wav"
    elseif ply:Team() == FACTION_OTA then
        newSound = "npc/combine_soldier/gear" .. math.random(1, 6) .. ".wav"
    elseif ply:IsVortigaunt() then
        newSound = "npc/vort/vort_foot" .. math.random(1, 4) .. ".wav"
    elseif ply:IsRebel() then
        local rand = math.random(1, 8)

        if rand == 7 then
            rand = 8
        end

        newSound = "npc/footsteps/hardboot_generic" .. rand .. ".wav"
    end

    if ply:KeyDown(IN_SPEED) then
        ply:EmitSound(newSound, 80, math.random(90, 110), 1)

        if not (newSound == sound) then
            ply:EmitSound(sound, 80, math.random(90, 110), 1)
        end
    else
        if not (ply:KeyDown(IN_DUCK) or ply:KeyDown(IN_WALK)) then
            ply:EmitSound(newSound, 70, math.random(90, 110), 0.2)

            if not (newSound == sound) then
                ply:EmitSound(sound, 70, math.random(90, 110), 0.2)
            end
        end
    end

    return true
end

local blacklistedEntities = {
    ["obj_vj_grenade"] = true,
    ["gmod_wire_explosive"] = true,
    ["gmod_wire_detonator"] = true
}

function Schema:OnEntityCreated(ent)
    if (ent:GetClass() == "prop_physics") and not ent:GetOwner() then
        timer.Simple(0, function()
            ent:Remove()
        end)
    end

    timer.Simple(0, function()
        if ent:IsValid() then
            ent:DrawShadow(false)

            if blacklistedEntities[ent:GetClass()] then
                MsgAll("REMOVED " .. ent:GetClass() .. "\n")

                if ent:GetOwner():IsPlayer() then
                    MsgAll(ent:GetOwner():Nick() .. "\n")
                else
                    MsgAll("Entity had no owner!\n")
                end

                ent:Remove()
            end

            if ent:GetClass():find("wire") and (ent:GetOwner():IsPlayer() and not (ent:GetOwner():IsDonator() or ent:GetOwner():IsAdmin())) then
                MsgAll("REMOVED ", tostring(ent), " FROM ", tostring(ent:GetOwner()))
                ent:Remove()
            end
        end
    end)
end

function Schema:simfphysUse(ent, ply)
    if ent:GetModel():find("combine_apc") then
        if not (ply:Team() == FACTION_CCA or FACTION_OTA) then
            if (ent.APCUseCoolDown or 0) < CurTime() then
                ply:ChatNotify("You can not enter the Combine APC due to it being biolocked!")
                ent:EmitSound("buttons/combine_button_locked.wav", 80)
                ent:EmitSound("ambient/alarms/apc_alarm_loop1.wav", 90)

                timer.Simple(15, function()
                    if IsValid(ent) then
                        ent:EmitSound("ambient/alarms/klaxon1.wav", 90, 80)
                        ent:StopSound("ambient/alarms/apc_alarm_loop1.wav")
                    end
                end)

                Schema:AddCombineDisplayMessage("attempted biolock bypass detected!", Color(255, 0, 0), true, "npc/roller/mine/rmine_blip3.wav")
                Schema:AddWaypoint(ent:GetPos(), "Attempted Biolock bypass detected!", Color(255, 0, 0), 120)
                ent.APCUseCoolDown = CurTime() + 15
            end

            return "no"
        else
            ply:ChatNotify("You bypassed the biolock on the Combine APC.")
            ent:EmitSound("buttons/combine_button1.wav", 80)
            Schema:AddCombineDisplayMessage("unit " .. ply:Nick() .. " entered armored personnel carrier..", team.GetColor(ply:Team()), true)
        end
    end
end

function Schema:ShowSpare2(ply)
    ply:ConCommand("ix_togglethirdperson")
end

function Schema:Move(ply, mv)
    local char = ply:GetCharacter()
    local walkPenalty = 0
    local runPenalty = 0
    local runBoost = 0

    if ply:Team() == FACTION_CITIZEN then
        runBoost = 5
    end

    if char then
        if char:GetData("ixBrokenLegs") then
            walkPenalty = 5
            runPenalty = 85
        elseif ply:IsRestricted() then
            walkPenalty = 3
            runPenalty = 75
        end
    end

    ply:SetDuckSpeed(0.4)
    ply:SetUnDuckSpeed(0.4)
    ply:SetSlowWalkSpeed(70)
    ply:SetCrouchedWalkSpeed(0.7)

    if ply:KeyDown(IN_FORWARD) and (ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_MOVERIGHT)) then
        ply:SetWalkSpeed(80 - walkPenalty)
        ply:SetRunSpeed(165 + runBoost - runPenalty)
    elseif ply:KeyDown(IN_FORWARD) then
        ply:SetWalkSpeed(90 - walkPenalty)
        ply:SetRunSpeed(180 + runBoost - runPenalty)
    elseif ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_MOVERIGHT) then
        ply:SetWalkSpeed(85 - walkPenalty)
        ply:SetRunSpeed(170 + runBoost - runPenalty)
    elseif ply:KeyDown(IN_BACK) then
        ply:SetWalkSpeed(60 - walkPenalty)
        ply:SetRunSpeed(130 + runBoost - runPenalty)
    end
end

local allowedPlayersContainers = {
    ["STEAM_0:1:65213148"] = true,
    ["STEAM_0:0:206764368"] = true,
}

function Schema:CanPlayerSpawnContainer(ply)
    if allowedPlayersContainers[ply:SteamID()] then
        MsgAll(ply:Nick(), " allowed to spawn container!")

        return true
    else
        return false
    end
end

function Schema:PlayerUse(ply, entity)
    if ply and IsValid(ply) then
        if ply:IsCombine() and entity:IsDoor() and IsValid(entity.ixLock) and ply:KeyDown(IN_SPEED) then
            entity.ixLock:Toggle(ply)

            return false
        end

        if not ply:IsRestricted() and ply:KeyDown(IN_SPEED) and entity:IsPlayer() and entity:IsRestricted() and not entity:GetNetVar("untying") then
            local tarchar = entity:GetCharacter()
            entity:SetNetVar("tying", false)
            entity:SetAction("You are being untied.", 1)
            entity:SetNetVar("untying", true)
            ply:EmitSound("physics/plastic/plastic_box_impact_bullet5.wav")
            ply:SetAction("Untying.", 1)
            ix.chat.Send(ply, "me", "unties the person in front of them.")

            ply:DoStaredAction(entity, function()
                ply.ixArrestedTarget = nil
                entity.ixArrestedBy = nil
                entity:SetRestricted(false)
                entity:SetNetVar("untying", false)
                tarchar:SetData("tied", false)
            end, 1, function()
                if IsValid(entity) then
                    entity:SetNetVar("untying", false)
                    entity:SetAction()
                end

                if IsValid(ply) then
                    ply:SetAction()
                end
            end)
        end
    end
end

function Schema:PlayerUseDoor(client, door)
    if client:IsCombine() or client:Team() == FACTION_CA then
        if not door:HasSpawnFlags(256) and not door:HasSpawnFlags(1024) then
            door:Fire("open")
        end
    end
end

function Schema:PlayerSpray(ply)
    return true
end

function Schema:OnDamagedByExplosion()
    return true
end

function Schema:PlayerCanHearPlayersVoice(listener, ply)
    if not (IsValid(ply) and ply:Alive() and ply:GetCharacter()) then return end
    if not (IsValid(listener) and listener:Alive() and listener:GetCharacter()) then return end
    if not ply:GetCharacter():HasFlags("V") then return false end

    return true
end

util.AddNetworkString("ixCustomSettings")

function Schema:PlayerLoadout(ply)
    timer.Simple(0.95, function()
        if ply:GetWeapon("gmod_tool") then
            ply:SelectWeapon("ix_hands")
        end
    end)

    local char = ply:GetCharacter()

    if char then
        ply:SetCanZoom(false)
        ply:ConCommand("gmod_mcore_test 1")
        net.Start("ixCustomSettings")
        net.Send(ply)

        for k, v in pairs(ents.GetAll()) do
            if v:IsNPC() then
                Schema:UpdateRelationShip(v)
            end
        end

        print(ply:IPAddress(), " ", ply:SteamName(), " [", ply:Nick(), "] - ", ply:SteamID(), " | PlayerLoadout")
    end

    function Schema:PlayerLoadedCharacter(ply, char, oldChar)
        if ply:IsAdmin() then
            char:GiveFlags("Cn")
            char:GiveFlags("pet")
        end
    end

    local dropAbleWeapons = {
        ["weapon_357"] = "357",
        ["tfa_ocipr"] = "ar1",
        ["tfa_ins2_smg"] = "smg",
        ["tfa_ins2_spas12"] = "spas12",
        ["tfa_ins2_usp_match"] = "usp",
        ["tfa_m1a1_thompson"] = "m1a1_thompson",
        ["tfa_ins2_remington_m870"] = "remington_m870",
        ["tfa_combineshotgun"] = "cmb_12g",
        ["ix_stunstick"] = "stunstick",
        ["weapon_crowbar"] = "crowbar",
        ["ls_axe"] = "axe",
        ["weapon_grenade"] = "grenade",
        ["tfa_crossbow"] = "crossbow",
        ["weapon_rpg"] = "rpg",
        ["tfa_nam_ppsh41"] = "ppsh",
        ["tfa_nam_m60"] = "m60",
        ["tfa_osips"] = "gruntsmg",
    }

    local function DropRandomWeapon(ply, held, dropAmmoInstead)
        if IsValid(held) and dropAbleWeapons[ply:GetActiveWeapon():GetClass()] and ply:Team() == FACTION_CCA or FACTION_OTA then
            if ply:GetActiveWeapon(weapons[1]) then return end
            local wep = dropAbleWeapons[held:GetClass()]

            if dropAbleWeapons then
                if wep then
                    ix.item.Spawn(wep, ply:GetPos() + Vector(0, 0, 40), nil, ply:GetAngles())
                end
            end
        else
            local weapons = {}

            for i, v in ipairs(ply:GetWeapons()) do
                local class = v:GetClass()

                if dropAbleWeapons[class] then
                    weapons[#weapons + 1] = dropAbleWeapons[class]
                end
            end

            if #weapons > 0 then
                local randWeapon = table.Random(weapons)
                ix.item.Spawn(randWeapon, ply:GetPos() + Vector(0, 0, 40), nil, ply:GetAngles())
            end
        end
    end

    function Schema:DoPlayerDeath(ply, inflicter, attacker)
        local randomChance = math.random(1, 3)
        ply.deathPos = ply:GetPos()
        ply.deathAngles = ply:GetAngles()
        ply.ixCWUClass = 0

        if ply:IsRestricted() then
            ply:Freeze(false)
        end

        local char = ply:GetCharacter()
        if not char then return end

        if ply:Team() == FACTION_OTA then
            ix.item.Spawn("damagedotavest", ply:GetPos() + Vector(0, 0, 60))
        end

        if ply:Team() == FACTION_CCA then
            ix.item.Spawn("damagedcpvest", ply:GetPos() + Vector(0, 0, 60))
        end

        local held = ply:GetActiveWeapon()

        if randomChance == 1 then
            if ply:IsCombine() then
                ix.item.Spawn("biolink", ply:GetPos() + Vector(0, 0, 50))
            else
                DropRandomWeapon(ply, held, true)
            end
        elseif ply:IsCombine() then
            DropRandomWeapon(ply, held, true)
        else
            DropRandomWeapon(ply, held)
        end

        if ply:IsBot() then return false end
        if char:GetMoney() == 0 then return end
        local droppedTokens = ents.Create("ix_money")
        droppedTokens:SetModel(ix.currency.model)
        droppedTokens:SetPos(ply:GetPos())
        droppedTokens:SetAngles(ply:GetAngles())
        droppedTokens:SetAmount(char:GetMoney())
        droppedTokens:Spawn()
        char:SetMoney(0)
    end

    function Schema:PlayerDeath(ply, inflictor, attacker)
        if not IsValid(ply) then return end
        local char = ply:GetCharacter()
        char:SetData("tied", false)
        ply:SetRestricted(false)
        ply:SetNetVar("tying", false)
        ply:SetNetVar("untying", false)
        ply:ConCommand("Stopsound")
        ply.ixJailState = nil

        if ply:IsCombine() then
            local location = ply:GetArea()

            if location == "" then
                location = "unknown location"
            end

            local combineName = string.upper(ply:Nick() or "unknown unit")

            local sounds = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/attention.wav", "npc/overwatch/radiovoice/lostbiosignalforunit.wav", "npc/overwatch/radiovoice/off4.wav", "hl1/fvox/_comma.wav", "npc/overwatch/radiovoice/on1.wav", "npc/overwatch/radiovoice/unitdownat.wav", "npc/overwatch/radiovoice/404zone.wav", "npc/overwatch/radiovoice/reinforcementteamscode3.wav", "npc/overwatch/radiovoice/investigateandreport.wav", "npc/overwatch/radiovoice/off2.wav",}

            for k, v in ipairs(player.GetAll()) do
                if v:IsCombine() then
                    ix.util.EmitQueuedSounds(v, sounds, 3, 0.2, 40)
                end
            end

            ply:SetNWBool("CPRespawn", true)
            ply:SetNWBool("AlreadyaRank", false)

            if ply:GetSquad() then
                ply:SetNetVar("squadleader", nil)
                ply:SetNetVar("squad", nil)
            end

            timer.Simple(math.random(4.00, 5.00), function()
                ix.chat.Send(ply, "dispatchradioforce", "Attention, lost biosignal for protection team unit " .. combineName .. ".", false)
                Schema:AddCombineDisplayMessage("Downloading lost biosignal...")

                timer.Simple(math.random(4.00, 5.00), function()
                    ix.chat.Send(ply, "dispatchradioforce", "Unit down at, " .. location .. " reinforcement teams code 3. Investigate and report.", false)
                    Schema:AddCombineDisplayMessage("WARNING! Biosignal lost for protection team unit " .. combineName .. " at " .. location .. "...", Color(255, 0, 0, 255))
                    Schema:AddWaypoint(ply.deathPos + Vector(0, 0, 30), "LOST BIOSIGNAL FOR " .. combineName, Color(200, 0, 0), 120, ply)
                end)
            end)
        end

        if attacker:IsNPC() and (attacker:GetClass() == "npc_headcrab" or attacker:GetClass() == "npc_headcrab_fast") then
            local headCrab = ents.Create("npc_zombie")

            if attacker:GetClass() == "npc_headcrab_fast" then
                headCrab = ents.Create("npc_fastzombie")
            end

            headCrab:SetPos(ply:GetPos())
            headCrab:SetAngles(ply:GetAngles())
            headCrab:Spawn()
            attacker:Remove()
            ply:Notify("A Headcrab has latched on to your body and is now taking control of it!")
        end

        if ply:Team() == FACTION_CITIZEN and char then
            char:SetClass(CLASS_CITIZEN)
        end

        if ply:Team() == FACTION_CITIZEN and char and ply:GetCharacter():GetClass() == CLASS_CITIZEN then
            ply:SetBodygroup(1, 0)
            ply:SetBodygroup(2, 0)
            ply:SetBodygroup(3, 0)
            ply:SetBodygroup(4, 0)
            ply:SetBodygroup(5, 0)
            ply:SetBodygroup(6, 0)
            ply:SetBodygroup(7, 0)
            ply:SetBodygroup(8, 0)
            ply:SetBodygroup(9, 0)
            ply:SetBodygroup(10, 0)
            ply:SetBodygroup(11, 0)
            ply:SetBodygroup(12, 0)
            ply:SetBodygroup(13, 0)
        elseif ply:Team() == FACTION_VORTIGAUNT then
            ply:SetBodygroup(7, 1)
            ply:SetBodygroup(8, 1)
            ply:SetBodygroup(9, 1)
        end
    end
end

function Schema:PlayerInteractItem(ply, action, item)
    if action == "drop" then
        timer.Simple(0.1, function()
            item:GetEntity():SetCollisionGroup(COLLISION_GROUP_WORLD)
        end)
    end
end

local allowedPlayersContainers = {
    ["STEAM_0:1:65213148"] = true,
    ["STEAM_0:0:206764368"] = true,
}

function Schema:CanPlayerSpawnContainer(ply)
    if allowedPlayersContainers[ply:SteamID()] then
        print(ply:Nick(), " allowed to spawn container!")

        return true
    else
        return false
    end
end

function Schema:ShouldSpawnClientRagdoll()
    return false
end

function Schema:ShouldRemoveRagdollOnDeath()
    return false
end

-- Prop Cost
function Schema:PlayerSpawnProp(ply)
    local char = ply:GetCharacter()

    if ply:IsAdmin() or (ply:IsCombine() and ply:Nick():find("GRID")) then
        ply:Notify("You did not pay any tokens to spawn this prop.")

        return true
    else
        return false, ply:Notify("You cannot spawn props right now")
    end

    if char:HasMoney(4) then
        char:TakeMoney(4)

        return true
    else
        return false, ply:Notify("You need 4 tokens!")
    end
end

function Schema:KeyPress(ply, key)
    if (key == IN_JUMP) and ply:IsOnGround() then
        ply:ViewPunch(Angle(-1, 0, 0))
    end
end

function Schema:OnPlayerHitGround(ply, inWater, onFloater, speed)
    if not inWater and ply:IsValid() and ply:GetCharacter() then
        local punch = (speed * 0.01) * 2
        ply:ViewPunch(Angle(punch, 0, 0))

        if punch >= 7 then
            ply:EmitSound("npc/combine_soldier/zipline_hitground" .. math.random(1, 2) .. ".wav", 60)

            if punch >= 11.0 then
                if not (ply:Team() == FACTION_OTA or ply:IsDispatch()) then
                    ply:TakeDamage(math.random(10, 20))
                    ply:EmitSound("player/pl_fallpain1.wav", 80)

                    if ply:GetCharacter():GetData("ixBrokenLegs", false) == true then
                        ply:ChatNotify("You broke your legs!")
                        ply:GetCharacter():SetData("ixBrokenLegs", true)

                        timer.Simple(65, function()
                            ply:GetCharacter():SetData("ixBrokenLegs", false)
                        end)

                        if ply:IsCombine() then
                            Schema:AddCombineDisplayMessage("WARNING! UNIT " .. string.upper(ply:Nick()) .. " RECEIVED LEG FRACTURE...", Color(200, 50, 0, 255))
                        end
                    end
                end
            else
                return
            end
        else
            return
        end
    else
        return
    end
end

local npcHealthValues = {
    ["npc_antlionguard"] = 1000,
    ["npc_antlion"] = 200,
    ["npc_hunter"] = 400,
    ["npc_combine_s"] = 140,
    ["npc_citizen"] = 100,
}

function Schema:PlayerSpawnedNPC(ply, ent)
    ent:SetKeyValue("spawnflags", "16384")
    ent:SetKeyValue("spawnflags", "2097152")
    ent:SetKeyValue("spawnflags", "8192")

    if ent.SetCurrentWeaponProficiency then
        ent:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
    end

    if npcHealthValues[ent:GetClass()] then
        ent:SetHealth(npcHealthValues[ent:GetClass()])
    end

    Schema:UpdateRelationShip(ent)
end

local painSounds = {
    [FACTION_CITIZEN] = {
        sound = function() return "" end
    },
    [FACTION_CCA] = {
        sound = function() return "npc/metropolice/pain" .. math.random(1, 4) .. ".wav" end
    },
    [FACTION_OTA] = {
        sound = function() return "npc/combine_soldier/pain" .. math.random(1, 3) .. ".wav" end
    },
    [FACTION_VORTIGAUNT] = {
        sound = function()
            return table.Random({"vo/npc/vortigaunt/vortigese02.wav", "vo/npc/vortigaunt/vortigese03.wav", "vo/npc/vortigaunt/vortigese04.wav", "vo/npc/vortigaunt/vortigese07.wav",})
        end
    },
}

function Schema:GetPlayerPainSound(ply)
    if painSounds[ply:Team()] and painSounds[ply:Team()].sound then return painSounds[ply:Team()].sound() end
end

function Schema:GetPlayerDeathSound()
    return false
end

local chatTypes = {
    ["ic"] = true,
    ["w"] = true,
    ["y"] = true,
    ["radio"] = true,
    ["importantradio"] = true,
    ["commandradio"] = true,
    ["dispatch"] = true,
    ["dispatchradio"] = true,
    ["ptradio"] = true
}

local radioChatTypes = {
    ["radio"] = true,
    ["importantradio"] = true,
    ["commandradio"] = true,
    ["dispatch"] = true,
    ["dispatchradio"] = true,
    ["ptradio"] = true
}

function Schema:PlayerMessageSend(speaker, chatType, text, anonymous, receivers, rawText)
    if chatTypes[chatType] then
        local class = self.voices.GetClass(speaker)

        for k, v in ipairs(class) do
            local info = self.voices.Get(v, rawText)

            if info then
                local volume = 80

                if chatType == "w" then
                    volume = 60
                elseif chatType == "y" then
                    volume = 150
                end

                if info.sound then
                    if info.global then
                        PlayEventSound(info.sound)
                    else
                        if radioChatTypes[chatType] then
                            for k, v in pairs(player.GetAll()) do
                                if (v:IsCombine() or v:IsCA() or v:IsDispatch()) and not (v == ply) then
                                    v:PlaySound(info.sound)
                                end
                            end
                        else
                            local sounds = {info.sound}

                            ix.util.EmitQueuedSounds(speaker, sounds, nil, nil, volume)
                        end
                    end
                end

                if speaker:IsCombine() then
                    return string.format("<:: %s ::>", info.text)
                else
                    return info.text
                end
            end
        end

        if speaker:IsCombine() or radioChatTypes[chatType] then return string.format("<:: %s ::>", text) end
    end
end

function Schema:InitPostEntity()
    for _, v in ipairs(ents.FindByClass("prop_door_rotating")) do
        if IsValid(v) and v:IsDoor() then
            v:DrawShadow(false)
        end
    end
end

function Schema:PlayerSpawnRagdoll(ply, model)
    if not ply:IsAdmin() then
        ply:Notify("You cannot spawn ragdolls!")

        return false
    end
end

function Schema:PlayerSpawnSENT(ply)
    if not ply:IsAdmin() then
        ply:Notify("You are not a admin!")

        return false
    end
end

function Schema:PlayerSpawnVehicle(ply)
    if not ply:IsAdmin() then
        ply:Notify("You are not a admin!")

        return false
    end
end

function Schema:CanPlayerUseCharacter(client, character)
    local banned = character:GetData("banned")

    if banned then
        if isnumber(banned) then
            if banned < os.time() then return end

            return false, "@charBannedTemp"
        end

        return false, "@charBanned"
    end

    if client:GetNWBool("ixActiveBOL") then return false, "You cannot change characters while you have a BOL!" end
    local bHasWhitelist = client:HasWhitelist(character:GetFaction())
    if not bHasWhitelist then return false, "@noWhitelist" end
end

concommand.Add("+mmm", function(ply, cmd, args)
    if cmd == "+mmm" then
        print("Blocked command: " .. cmd)
    end
end)

hook.Add("SetupMove", "BlockCommand", function(ply, move)
    if move:GetImpulseCommand() == 103 then return true end -- The impulse command for "+mmm" is 103 -- Return true to block the command
end)

netstream.Hook("PlayerChatTextChanged", function(client, key)
    if client:IsCombine() and not client.bTypingBeep then
        client:EmitSound("hlacomvoice/beepboops/combine_radio_on_09.wav")
        client.bTypingBeep = true
    end
end)

netstream.Hook("PlayerFinishChat", function(client)
    if client:IsCombine() and client.bTypingBeep then
        client:EmitSound("hlacomvoice/beepboops/combine_radio_off_06.wav")
        client.bTypingBeep = nil
    end
end)