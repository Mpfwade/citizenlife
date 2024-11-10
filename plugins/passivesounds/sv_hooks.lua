function PLUGIN:EmitRandomChatter(position)
    local randomSounds = {"ambient/machines/heli_pass_distant1.wav", "ambient/wind/wind_moan4.wav", "ambient/wind/wind_moan2.wav", "ambient/wind/wind_moan1.wav", "ambient/alarms/manhack_alert_pass1.wav", "ambient/alarms/apc_alarm_pass1.wav", "ambient/levels/streetwar/city_battle16.wav", "ambient/levels/streetwar/gunship_distant2.wav", "ambient/levels/streetwar/city_chant1.wav"}

    local randomSound = randomSounds[math.random(1, #randomSounds)]

    -- Play the sound at the specified position and sound level
    sound.Play(randomSound, position, 100)
end

function PLUGIN:Tick()
    for k, v in ipairs(player.GetAll()) do
        local curTime = CurTime()

        if not self.nextChatterEmit then
            self.nextChatterEmit = curTime + math.random(15, 20)
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
            Vector(3445, -2069, 780),
            Vector(-1660, -1445, 599),
            Vector(-804, 571, 702),
            Vector(3382, 929, 758),
            Vector(2212, 48, 754),
            Vector(2992, 75, 904),
            Vector(2036, -1919, -182),
            Vector(-2332, -1281, 246),
        }
        --]]

        --[[

        local positions = { -- c28
            Vector(-1277.336182, 4852.377441, 1162.044678),
            Vector(-2881.995117, 862.743347, 797.532898),
            Vector(2106.751465, -947.593323, 742.668823),
            Vector(-15.024372, -3335.919189, 713.549438),
            Vector(-1798.148071, -871.619385, 1060.519287),
            Vector(-2522.136230, 3573.199951, 989.428955),
            Vector(8387.103516, 1051.112305, 971.800842),
            Vector(7076.083984, 5288.955566, 1146.094238),
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
         Vector(4642.844727, 1771.535278, 747.132385),
         Vector(5767.017090, 2970.336182, 677.472473),
         Vector(4882.893555, 4618.112793, 721.126831),
         Vector(3488.753174, 3130.019531, 766.858154),
         Vector(766.160522, 2104.332275, 557.678711),
         Vector(-445.197571, 3561.719727, 636.535583),
         Vector(2797.741455, 4971.752441, 750.448792),
         Vector(3791.218994, 8315.319336, 641.853821),
     }

            local position = positions[math.random(1, #positions)]

            -- Pass the position to EmitRandomChatter
            self:EmitRandomChatter(position)
        end
    end
end
