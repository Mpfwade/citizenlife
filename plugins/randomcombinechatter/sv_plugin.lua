local PLUGIN = PLUGIN


function PLUGIN:EmitRandomChatter(player)
    local chatterSounds = {
        "combinesounds/chatter_cp1.wav",
        "combinesounds/chatter_cp3.wav",
        "combinesounds/chatter_cp5.wav",
        "combinesounds/chatter_cp6.wav",
        }
            local randomChatter = chatterSounds[math.random(1, #chatterSounds)]
            if player:InChatterArea() then
            player:PlaySound(randomChatter, 32)
        end
    end

function PLUGIN:Tick()
    for k, v in ipairs(player.GetAll()) do
        local curTime = CurTime()

        if not self.nextChatterEmit then
            self.nextChatterEmit = curTime + math.random(10, 30)
        end

        if curTime >= self.nextChatterEmit then
            self.nextChatterEmit = nil
            self:EmitRandomChatter(v)
        end
    end
end