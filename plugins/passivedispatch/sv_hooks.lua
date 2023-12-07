function PLUGIN:EmitRandomChatter(position)
    local randomSounds = {
        Sound("npc/overwatch/cityvoice/f_innactionisconspiracy_spkr.wav"),
        Sound("dispatch/disp_civilized.wav")
    }
    local randomSound = randomSounds[math.random(1, #randomSounds)]

    -- Play the sound at the specified position and sound level
    sound.Play(randomSound, position, 100)
end

function PLUGIN:Tick()
    for k, v in ipairs(player.GetAll()) do
        local curTime = CurTime()

        if not self.nextChatterEmit then
            self.nextChatterEmit = curTime + math.random(55, 200)
        end

        if curTime >= self.nextChatterEmit then
            self.nextChatterEmit = nil

            local positions = { -- city 11
                Vector(-3630, -1989, -538),
                Vector(-3065, -136, -366),
                Vector(-5686, -1464, -659),
                Vector(-1582, -1700, -673),
                Vector(-2075, -3952, -541),
                Vector(-4165, -1433, 572),
                Vector(-4418, -3099, 743),
            }
            local position = positions[math.random(1, #positions)]

            -- Pass the position to EmitRandomChatter
            self:EmitRandomChatter(position)
        end
    end
end
