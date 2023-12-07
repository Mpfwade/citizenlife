function PLUGIN:EmitRandomChatter(player)
    local randomSounds = {"c17/c17pa0.wav", "c17/c17pa1.wav", "c17/c17pa2.wav", "c17/c17pa3.wav", "c17/c17pa4.wav"}

    player:EmitSound("ambient/alarms/warningbell1.wav", 45)
    local randomSound = randomSounds[math.random(1, #randomSounds)]

    player:EmitSound(randomSound, 45)
end

-- Color(128, 218, 235)
function PLUGIN:Tick()
    for k, v in ipairs(player.GetAll()) do
        local curTime = CurTime()

        if (not self.nextChatterEmit) then
            self.nextChatterEmit = curTime + math.random(110, 310)
        end

        if ((curTime >= self.nextChatterEmit)) then
            self.nextChatterEmit = nil
            self:EmitRandomChatter(v)
        end
    end
end