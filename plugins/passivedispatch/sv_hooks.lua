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

            --[[
            local positions = { -- city 11
                Vector(-3630, -1989, -538),
                Vector(-3065, -136, -366),
                Vector(-5686, -1464, -659),
                Vector(-1582, -1700, -673),
                Vector(-2075, -3952, -541),
                Vector(-4165, -1433, 572),
                Vector(-4418, -3099, 743),
            }

            --]]

--[[
            local positions = { -- D47
            Vector(3235, -975, 879),
            Vector(2459, 406, 880),
            Vector(-212, 857, 850),
            Vector(-622, -1444, 1079),
            Vector(-1565, -287, 1026),
            Vector(2368, -2301, 1026),
            Vector(-3834, -1205, 613),
        }
        --]]

        --[[
        local positions = { -- C28
            Vector(5167, 3825, 1127),
            Vector(8482, 971, 906),
            Vector(-76, -750, 1029),
            Vector(-2375, 2680, 1027),
            Vector(-473, 3609, 1055),
        }
         --]]

         --[[
         local positions = { -- i17 v3
         Vector(1824.268677, 3587.510498, 583.499390),
         Vector(2946.163330, 4856.437500, 783.097046),
         Vector(3144.774902, 2054.144531, 358.055450),
         Vector(-23.935167, 1981.691895, 332.984406),
         Vector(5579.365723, 4613.965820, 958.539246),
         Vector(4953.374512, 2771.828369, 1370.483643),
         Vector(-318.816833, 8099.869629, 2219.388428),
         Vector(1612.940430, 1622.473145, 1650.228638),
     }
         --]]

         local positions = { -- i17 apex
         Vector(1826.869263, 3588.063477, 860.807556),
         Vector(-868.307129, 2849.156494, 1059.451416),
         Vector(3340.878906, 1560.355591, 1108.468018),
         Vector(3850.987549, 4685.023926, 1246.971558),
         Vector(6353.807617, 2768.334717, 1116.019043),
         Vector(2235.111572, 4963.344238, 1273.772217),
         Vector(3518.844971, 3202.297852, 1325.329834),
         Vector(904.334961, 2101.250000, 1099.320068),
     }

            local position = positions[math.random(1, #positions)]

            -- Pass the position to EmitRandomChatter
            self:EmitRandomChatter(position)
        end
    end
end
