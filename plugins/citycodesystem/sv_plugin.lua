local PLUGIN = PLUGIN

function PLUGIN:CivilUnrestStart()
    SetGlobalBool("ixCUStatus", true)

    local sounds = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/attention.wav", "npc/overwatch/radiovoice/politistablizationmarginal.wav", "npc/overwatch/radiovoice/off2.wav"}

    for k, v in ipairs(player.GetAll()) do
        if v:IsCombine() then
            ix.util.EmitQueuedSounds(v, sounds, 0, 0.2, 150)
        end
    end

    PlayEventSound("music/stingers/hl1_stinger_song27.mp3")
    PlayTimedEventSound(9, "alarms/choreo_a1_intro_basement_alarm.mp3")
    EmitTimedShake(9)
    PlayTimedEventSound(13, "npc/overwatch/cityvoice/f_unrestprocedure1_spkr.wav")

    timer.Create("ixUnrestSiren", 10, 0, function()
        PlayTimedEventSound(3.15, "hlacomvoice/alarms/amb_c17_distant_alarm_02_rs.mp3")
        EmitTimedShake(3.15)
    end)
end

function PLUGIN:CivilUnrestStop()
    SetGlobalBool("ixCUStatus", false)
    timer.Remove("ixUnrestSiren")

    local sounds = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/attention.wav", "npc/overwatch/radiovoice/sociostabilizationrestored.wav", "npc/overwatch/radiovoice/off2.wav"}

    for k, v in ipairs(player.GetAll()) do
        if v:IsCombine() then
            ix.util.EmitQueuedSounds(v, sounds, 0, 0.2, 150)
        end
    end
end

--[[---------------------------------------------------------------------------
	City Turmoil
---------------------------------------------------------------------------]]
--
function PLUGIN:CityTurmoilStart()
    local sounds = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/attention.wav", "npc/overwatch/radiovoice/socialfractureinprogress.wav", "npc/overwatch/radiovoice/allteamsrespondcode3.wav", "npc/overwatch/radiovoice/off2.wav"}

    for k, v in ipairs(player.GetAll()) do
        if v:IsCombine() then
            ix.util.EmitQueuedSounds(v, sounds, 0, 0.2, 150)
        end
    end

    SetGlobalBool("ixCTStatus", true)
    PlayEventSound("music/stingers/hl1_stinger_song28.mp3")
    PlayTimedEventSound(5, "npc/overwatch/cityvoice/f_protectionresponse_5_spkr.wav")
    PlayTimedEventSound(6, "music/destabilizing3.wav")
    PlayTimedEventSound(10, "ambient/levels/citadel/citadel_5sirens3.wav")
    PlayTimedEventSound(13, "ambient/levels/citadel/stalk_traindooropen.wav")
    PlayTimedEventSound(15, "ambient/levels/citadel/citadel_5sirens3.wav")
    PlayTimedEventSound(18, "ambient/levels/streetwar/heli_distant1.wav")
    PlayTimedEventSound(20, "music/a1_intro_refuge.mp3")
    PlayTimedEventSound(23, "ambient/levels/streetwar/gunship_distant1.wav")
    PlayTimedEventSound(25, "ambient/levels/streetwar/gunship_distant2.wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")

    for _, v in pairs(player.GetAll()) do
        util.ScreenShake(v:GetPos(), 2, 5, 3, 500)
    end

    timer.Simple(4, function()
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")

        for _, v in pairs(player.GetAll()) do
            util.ScreenShake(v:GetPos(), 2, 5, 3, 500)
        end
    end)

    timer.Simple(7, function()
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")

        for _, v in pairs(player.GetAll()) do
            util.ScreenShake(v:GetPos(), 2, 5, 3, 500)
        end
    end)

    timer.Simple(7, function()
        timer.Create("ixCityTurmoilAmbience", 10, 0, function()
            local randomChance = math.random(1, 5)

            PlayEventSound({"ambient/levels/streetwar/marching_distant1.wav", "ambient/levels/streetwar/marching_distant2.wav", "ambient/levels/streetwar/apc_distant1.wav", "alarms/amb_c17_siren_distant_01_rs.mp3",})
        end)
    end)

    for _, v in pairs(ents.FindByName("citadel")) do
        v:Fire("SetAnimation", "open")
    end
end

function PLUGIN:CityTurmoilStop()
    SetGlobalBool("ixCTStatus", false)
    timer.Remove("ixCityTurmoilAmbience")
    timer.Remove("ixTurmoilBuzz")

    for _, v in pairs(ents.FindByName("citadel")) do
        v:Fire("SetAnimation", "idle")
    end
end

--[[---------------------------------------------------------------------------
	Judgement Waiver
---------------------------------------------------------------------------]]
--
function PLUGIN:JudgementWaiverStart()
    SetGlobalBool("ixJWStatus", true)
    PlayEventSound("music/a1_intro_strider.mp3")
    PlayEventSound("alarms/alarm.wav")
    EmitShake()
    PlayTimedEventSound(4, "dispatch/disp_assetallocation.wav")
    PlayTimedEventSound(15.9, "ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    EmitTimedShake(16)
    PlayTimedEventSound(20, "ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    EmitTimedShake(20.1)
    PlayTimedEventSound(22, "ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    EmitTimedShake(22.8)

    timer.Create("ixJWBuzz", 16, 0, function()
        PlayEventSound("loudspeaker/jw_horn.wav")
    end)

    for _, v in pairs(ents.FindByName("citadel")) do
        v:Fire("SetAnimation", "open")
    end
end

function PLUGIN:JudgementWaiverStopSilent()
    SetGlobalBool("ixJWStatus", false)
    timer.Remove("ixJWBuzz")

    for _, v in pairs(ents.FindByName("citadel")) do
        v:Fire("SetAnimation", "idle")
    end
end

function PLUGIN:JudgementWaiverStop()
    SetGlobalBool("ixJWStatus", false)
    timer.Remove("ixJWBuzz")

    for _, v in pairs(ents.FindByName("citadel")) do
        v:Fire("SetAnimation", "idle")
    end
end

--[[---------------------------------------------------------------------------
	Autonomous Judgement
---------------------------------------------------------------------------]]
--
function PLUGIN:AutonomousJudgementStart()
    for k, v in pairs(player.GetAll()) do
        net.Start("ixEventMessage")
        net.WriteString("Prepare yourselves..")
        net.Send(v)
    end

    PlayEventSound("music/hallway_long.wav")
    PlayTimedEventSound(1, "ambient/levels/citadel/citadel_5sirens3.wav")
    PlayTimedEventSound(3, "ambient/levels/citadel/strange_talk" .. math.random(1, 11) .. ".wav")
    PlayTimedEventSound(6, "ambient/levels/citadel/strange_talk" .. math.random(1, 11) .. ".wav")
    PlayTimedEventSound(10, "ambient/levels/citadel/portal_open1_adpcm.wav")
    PlayTimedEventSound(12, "dispatch/disp_void.wav")
    PlayTimedEventSound(12, "ambient/levels/citadel/core_partialcontain_loop1.wav")
    PlayTimedEventSound(12, "ambient/levels/citadel/citadel_drone_loop1.wav")
    PlayTimedEventSound(30, "npc/overwatch/cityvoice/f_protectionresponse_4_spkr.wav")

    timer.Simple(12, function()
        SetGlobalBool("ixAJStatus", true)
        local portalStormClouds = ents.Create("prop_dynamic")
        portalStormClouds:SetPos(Vector(-14115.766602, -13259.793945, 13184.562500))
        portalStormClouds:SetModel("models/props_combine/combine_citadelcloud001c.mdl")
        portalStormClouds:SetModelScale(0.75)
        portalStormClouds:Spawn()
        local portalStorm = ents.Create("prop_dynamic")
        portalStorm:SetPos(Vector(-14115.766602, -13259.793945, -13454.562500))
        portalStorm:SetModel("models/props_combine/combine_citadelcloudcenter.mdl")
        portalStorm:SetModelScale(0.75)
        portalStorm:Spawn()
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/atmosphere/hole_hit" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/atmosphere/terrain_rumble1.wav")

        for _, v in pairs(player.GetAll()) do
            util.ScreenShake(v:GetPos(), 2, 5, 5, 5000)
        end

        PlayEventSound("ambient/levels/labs/teleport_weird_voices" .. math.random(1, 2) .. ".wav")
        PlayEventSound("ambient/levels/labs/teleport_postblast_thunder1.wav")

        for _, v in pairs(player.GetAll()) do
            v:ScreenFade(SCREENFADE.IN, color_white, 5, 0)
        end

        timer.Create("ixAJAmbiencePortal", 7, 0, function()
            PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
            PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
            PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
            PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
            PlayEventSound("ambient/atmosphere/hole_hit" .. math.random(1, 5) .. ".wav")

            for _, ply in pairs(player.GetAll()) do
                util.ScreenShake(ply:GetPos(), 2, 5, 2, 5000)
            end

            PlayEventSound({"ambient/levels/city/citadel_cloudhit1.wav", "ambient/levels/city/citadel_cloudhit2.wav", "ambient/levels/city/citadel_cloudhit3.wav", "ambient/levels/city/citadel_cloudhit4.wav", "ambient/levels/city/citadel_cloudhit5.wav",})
        end)

        timer.Create("ixAJAmbience", 3, 0, function()
            PlayEventSound({"ambient/levels/streetwar/city_battle1.wav", "ambient/levels/streetwar/city_battle2.wav", "ambient/levels/streetwar/city_battle3.wav", "ambient/levels/streetwar/city_battle4.wav", "ambient/levels/streetwar/city_battle5.wav", "ambient/levels/streetwar/city_battle6.wav", "ambient/levels/streetwar/city_battle7.wav", "ambient/levels/streetwar/city_battle8.wav", "ambient/levels/streetwar/city_battle9.wav", "ambient/levels/streetwar/city_battle10.wav", "ambient/levels/streetwar/city_battle11.wav", "ambient/levels/streetwar/city_battle12.wav", "ambient/levels/streetwar/city_battle13.wav", "ambient/levels/streetwar/city_battle14.wav", "ambient/levels/streetwar/city_battle15.wav", "ambient/levels/streetwar/city_battle16.wav", "ambient/levels/streetwar/city_battle17.wav", "ambient/levels/streetwar/city_battle18.wav", "ambient/levels/streetwar/city_battle19.wav", "ambient/levels/streetwar/distant_battle_dropship01.wav", "ambient/levels/streetwar/distant_battle_dropship02.wav", "ambient/levels/streetwar/distant_battle_dropship03.wav", "ambient/levels/streetwar/distant_battle_gunfire01.wav", "ambient/levels/streetwar/distant_battle_gunfire02.wav", "ambient/levels/streetwar/distant_battle_gunfire03.wav", "ambient/levels/streetwar/distant_battle_gunfire04.wav", "ambient/levels/streetwar/distant_battle_gunfire05.wav", "ambient/levels/streetwar/distant_battle_gunfire06.wav", "ambient/levels/streetwar/distant_battle_gunfire07.wav", "ambient/levels/streetwar/distant_battle_shotgun01.wav", "ambient/levels/streetwar/distant_battle_soldier01.wav", "ambient/levels/streetwar/strider_1.wav", "ambient/levels/streetwar/strider_2.wav", "ambient/levels/streetwar/strider_3.wav",})
        end)
    end)

    timer.Create("ixAJFlasher", 60, 0, function()
        PlayEventSound("ambient/levels/citadel/portal_beam_shoot" .. math.random(1, 6) .. ".wav")
        PlayEventSound("ambient/levels/citadel/strange_talk" .. math.random(1, 11) .. ".wav")
        PlayEventSound("ambient/levels/citadel/strange_talk" .. math.random(1, 11) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/atmosphere/hole_hit" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/atmosphere/terrain_rumble1.wav")

        for _, v in pairs(player.GetAll()) do
            util.ScreenShake(v:GetPos(), 2, 5, 5, 5000)
        end

        PlayEventSound("ambient/levels/labs/teleport_weird_voices" .. math.random(1, 2) .. ".wav")
        PlayEventSound("ambient/levels/labs/teleport_postblast_thunder1.wav")

        for _, v in pairs(player.GetAll()) do
            v:ScreenFade(SCREENFADE.IN, color_white, 5, 0)
        end
    end)
end

function PLUGIN:AutonomousJudgementStop()
    timer.Remove("ixAJFlasher")
    timer.Remove("ixAJAmbiencePortal")
    timer.Remove("ixAJAmbience")
    PlayEventSound("ambient/levels/citadel/citadel_flyer1.wav")
    PlayTimedEventSound(3, "ambient/levels/citadel/citadel_5sirens.wav")
    PlayTimedEventSound(4, "ambient/levels/citadel/stalk_traindooropen.wav")
    PlayTimedEventSound(6, "ambient/levels/citadel/portal_beam_shoot" .. math.random(1, 6) .. ".wav")
    PlayTimedEventSound(8, "ambient/levels/citadel/portal_beam_shoot" .. math.random(1, 6) .. ".wav")
    PlayTimedEventSound(9, "ambient/levels/labs/teleport_mechanism_windup5.wav")

    timer.Simple(17, function()
        PlayEventSound("ambient/levels/citadel/portal_beam_shoot" .. math.random(1, 6) .. ".wav")
        PlayEventSound("ambient/levels/citadel/portal_beam_shoot" .. math.random(1, 6) .. ".wav")
        PlayTimedEventSound(1, "ambient/levels/labs/teleport_winddown1.wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/atmosphere/hole_hit" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/atmosphere/terrain_rumble1.wav")

        for _, v in pairs(player.GetAll()) do
            util.ScreenShake(v:GetPos(), 2, 5, 5, 5000)
        end

        PlayEventSound("ambient/levels/labs/teleport_weird_voices" .. math.random(1, 2) .. ".wav")
        PlayEventSound("ambient/levels/labs/teleport_postblast_thunder1.wav")

        for _, v in pairs(player.GetAll()) do
            v:ScreenFade(SCREENFADE.IN, color_white, 5, 0)
        end

        SetGlobalBool("ixAJStatus", false)

        for _, v in ipairs(player.GetAll()) do
            v:StopSound("ambient/levels/citadel/core_partialcontain_loop1.wav")
            v:StopSound("ambient/levels/citadel/citadel_drone_loop1.wav")
        end

        for _, v in pairs(ents.FindByClass("prop_dynamic")) do
            if (v:GetModel() == "models/props_combine/combine_citadelcloudcenter.mdl") or (v:GetModel() == "models/props_combine/combine_citadelcloud001c.mdl") then
                SafeRemoveEntity(v)
            end
        end
    end)

    timer.Simple(6, function()
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/atmosphere/hole_hit" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/atmosphere/terrain_rumble1.wav")

        for _, v in pairs(player.GetAll()) do
            util.ScreenShake(v:GetPos(), 2, 5, 5, 5000)
        end

        PlayEventSound("ambient/levels/labs/teleport_weird_voices" .. math.random(1, 2) .. ".wav")
        PlayEventSound("ambient/levels/labs/teleport_postblast_thunder1.wav")

        for _, v in pairs(player.GetAll()) do
            v:ScreenFade(SCREENFADE.IN, color_white, 5, 0)
        end
    end)

    timer.Simple(8, function()
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/atmosphere/hole_hit" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/atmosphere/terrain_rumble1.wav")

        for _, v in pairs(player.GetAll()) do
            util.ScreenShake(v:GetPos(), 2, 5, 5, 5000)
        end

        PlayEventSound("ambient/levels/labs/teleport_weird_voices" .. math.random(1, 2) .. ".wav")
        PlayEventSound("ambient/levels/labs/teleport_postblast_thunder1.wav")

        for _, v in pairs(player.GetAll()) do
            v:ScreenFade(SCREENFADE.IN, color_white, 5, 0)
        end
    end)
end