local PLUGIN = PLUGIN
PLUGIN.name = "Area-Based Stuff"
PLUGIN.author = "Wade"
PLUGIN.description = "Plays music in some areas."
ix.config.Add("area-music", true, "Should the music be on?", nil, {
    category = PLUGIN.name
})

ix.option.Add("area-music", ix.type.bool, true, {
    category = PLUGIN.name -- tis cool trolololol
})

ix.option.Add("area-music volume", ix.type.number, 100, {
    category = PLUGIN.name,
    min = 0,
    max = 100
})

local MUSIC_INFO = {
    ["Nexus Entrance"] = {
        name = "music/hl2_song25_teleporter.mp3",
        volume = 100
    },
    ["PATH TO THE OUTLANDS"] = {
        name = "music/hl1_song9.mp3",
        volume = 100
    },
    ["Residential Block 2"] = {
        name = "ambient/a1_intro_apt_radio.wav",
        volume = 100
    },
    ["Sector-1"] = {
        name = "music/hl2_song13.mp3",
        volume = 100
    },
    ["Sector-2"] = {
        name = "music/hl2_song1.mp3",
        volume = 100
    },
    ["Sector-3"] = {
        name = "music/hl2_song33.mp3",
        volume = 100
    },
    ["RB-1 Storage"] = {
        name = "music/a3_rooftop_crab_hotel_dark.mp3",
        volume = 100
    },
    ["Rebel Hideout"] = {
        name = "music/vlvx_song20.mp3",
        volume = 100
    },
    ["Under Hideout"] = {
        name = "music/vlvx_song3.mp3",
        volume = 100
    },
    ["PRISONER TRANSPORT 2491"] = {
        name = "music/stingers/hl1_stinger_song27.mp3",
        volume = 100
    },
    ["PRISONER INSERT"] = {
        name = "music/hl2_song0.mp3",
        volume = 100
    },
    ["Terminal Restriction Zone"] = {
        name = "music/stingers/hl1_stinger_song7.mp3",
        volume = 100
    },
    ["Prison"] = {
        name = "music/hl2_song19.mp3",
        volume = 100
    },
    ["Intake-Hub"] = {
        name = "music/hl2_song26_trainstation1.mp3",
        volume = 100
    },
    ["404 Zone"] = {
        name = "ambient/atmosphere/sewer_air1.wav",
        volume = 100
    },
}

if SERVER then
    util.AddNetworkString("AreaMusic")
    function PLUGIN:OnPlayerAreaChanged(client, old, new)
        local musicInfo = MUSIC_INFO[new]
        if new and musicInfo and not client.chaseMusic then
            net.Start("AreaMusic")
            net.WriteString(musicInfo.name)
            net.Send(client)
        elseif not new or not musicInfo then
            net.Start("AreaMusic")
            net.WriteString("") --
            net.WriteFloat(0)
            net.Send(client)
        end
    end
else -- CLIENT
    local currentMusic = nil
    local lastMusicChangeTime = 0
    local musicChangeCooldown = 1 -- Seconds before another music change can occur
    net.Receive("AreaMusic", function()
        local musicName = net.ReadString()
        local volume = ix.option.Get("area-music volume")
        local currentTime = CurTime()
        if currentTime - lastMusicChangeTime < musicChangeCooldown then -- Check if we are within the cooldown period
            return
        end

        if musicName == "" then -- Stop current music if an empty string is received
            if currentMusic and currentMusic:IsPlaying() then
                currentMusic:FadeOut(1)
                currentMusic = nil
            end

            lastMusicChangeTime = currentTime
            return
        end

        if musicName and musicName ~= "" and (ix.option.Get("area-music", true) or musicName == MUSIC_INFO["404 Zone"].name) and ix.config.Get("cityCode") < 1 then -- Play new music if available
            if currentMusic and currentMusic:IsPlaying() then currentMusic:FadeOut(1) end
            currentMusic = CreateSound(LocalPlayer(), musicName)
            currentMusic:SetSoundLevel(volume)
            currentMusic:Play()
            currentMusic:SetDSP(0)
            lastMusicChangeTime = currentTime
        end
    end)
end

if SERVER then
    function PLUGIN:CheckChaseMusic(player)
        -- Immediately stop music if player is noclipping
        if player:GetMoveType() == MOVETYPE_NOCLIP then
            if player.chaseMusic then
                player.chaseMusic = false -- Reset the chase music flag
                -- Send a network message to stop the music
                net.Start("AreaMusic")
                net.WriteString("")
                net.WriteFloat(0)
                net.Send(player)
            end
            return
        end

        if player:Team() == FACTION_CCA then
            local velocity = player:GetVelocity():Length()
            local runningSpeed = 165
            local chasing = false
            local chasedPlayer = nil

            if velocity > runningSpeed then
                player.runningSince = player.runningSince or CurTime()
                if CurTime() - player.runningSince >= 5 then -- Only consider running for more than 5 seconds
                    for _, target in ipairs(ents.FindInSphere(player:GetPos(), 350)) do
                        if target:IsPlayer() and target:Team() == FACTION_CITIZEN then
                            local targetVelocity = target:GetVelocity():Length()
                            if targetVelocity > runningSpeed and player:GetPos():Distance(target:GetPos()) < 350 then
                                chasing = true
                                chasedPlayer = target
                                player.lastChaseTime = CurTime()
                                break
                            end
                        end
                    end
                end
            else
                player.runningSince = nil
            end

            local chaseMusicTracks = {"music/hl1_song10.mp3", "music/hl2_song12_long.mp3", "music/hl2_song15.mp3", "music/hl2_song20_submix4.mp3", "music/hl2_song4.mp3", "music/hl2_song31.mp3", "music/hl2_song6.mp3"}

            if chasing and not player.chaseMusic then
                player.chaseMusic = true
                local randomTrack = table.Random(chaseMusicTracks)
                
                net.Start("AreaMusic")
                net.WriteString(randomTrack)
                net.WriteFloat(1)
                net.Send(player)

                if chasedPlayer and not chasedPlayer.chaseMusic then
                    chasedPlayer.chaseMusic = true
                    net.Start("AreaMusic")
                    net.WriteString(randomTrack)
                    net.WriteFloat(1)
                    net.Send(chasedPlayer)
                end

            elseif player.chaseMusic and CurTime() - (player.lastChaseTime or 0) > 2 then
                player.chaseMusic = false

                net.Start("AreaMusic")
                net.WriteString("")
                net.WriteFloat(0)
                net.Send(player)

                if chasedPlayer and chasedPlayer.chaseMusic then
                    chasedPlayer.chaseMusic = false
                    net.Start("AreaMusic")
                    net.WriteString("")
                    net.WriteFloat(0)
                    net.Send(chasedPlayer)
                end
            end
        end
    end

    hook.Add("Think", "CheckChaseMusic", function()
        for _, ply in ipairs(player.GetAll()) do
            PLUGIN:CheckChaseMusic(ply)
        end
    end)
end
