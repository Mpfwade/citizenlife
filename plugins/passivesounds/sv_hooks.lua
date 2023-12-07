function PLUGIN:EmitRandomChatter(player)
    local randomSounds = {"ambient/machines/heli_pass_distant1.wav", "ambient/wind/wind_moan4.wav", "ambient/wind/wind_moan2.wav", "ambient/wind/wind_moan1.wav", "ambient/alarms/manhack_alert_pass1.wav", "ambient/alarms/apc_alarm_pass1.wav", "ambient/levels/labs/teleport_postblast_thunder1.wav", "ambient/levels/streetwar/city_battle16.wav", "ambient/levels/streetwar/gunship_distant2.wav", "ambient/levels/streetwar/city_chant1.wav"}

    local randomSound = randomSounds[math.random(1, #randomSounds)]

    if not self:IsPlayerOutside(player) then
        return -- Don't play the sound if the player is not outside
    end

    player:EmitSound(randomSound)
end

function PLUGIN:IsPlayerOutside(player)
    local startPos = player:GetShootPos()
    local endPos = startPos + Vector(0, 0, 1000) -- Extend the trace line upwards

    local trace = util.TraceLine({
        start = startPos,
        endpos = endPos,
        mask = MASK_SOLID_BRUSHONLY -- Only check against world geometry
    })

    return not trace.HitSky -- Return true if the trace doesn't hit the sky
end
