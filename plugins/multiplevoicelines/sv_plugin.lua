local PLUGIN = PLUGIN
local Schema = Schema

local chatTypes = {
    ['ic']                          = true,
    ['w']                           = true,
    ['y']                           = true,
    ['radio']                       = true,
    ['radio_yell']                  = true,
    ['radio_whisper']               = true,
    ['radio_eavesdrop']             = true,
    ['radio_eavesdrop_whisper']     = true,
    ['radio_eavesdrop_yell']        = true,
    ['dispatch']                    = true,
    ['dispatchradio']               = true,
	['ptradio'] = true
}

local radioChatTypes = {
	['radio'] 			= true,
	['importantradio'] 	= true,
	['commandradio'] 	= true,
	['dispatch'] 		= true,
	['dispatchradio'] 	= true,
	['ptradio'] = true
}

local validEnds = {['.'] = true, ['?'] = true, ['!'] = true}

local offSounds = {
    "npc/metropolice/vo/off1.wav",
    "npc/metropolice/vo/off2.wav",
    "npc/metropolice/vo/off3.wav",
    "npc/metropolice/vo/off4.wav",
}

-- Override PlayerMessageSend to play "off" sound only after the last voiceline
local real_table = Schema.PlayerMessageSend and Schema or PLUGIN
function real_table:PlayerMessageSend(speaker, chatType, text, anonymous, receivers, rawText)
    local function fixMarkup(a, b)
        return a..' '..string.upper(b)
    end

    if chatTypes[chatType] then
        local class = Schema.voices.GetClass(speaker)

        local textTable = string.Explode('; ?', rawText, true)
        local voiceList = {}

        for k, v in ipairs(textTable) do
            local bFound = false
            local text = string.upper(v)

            local info

            for _, c in ipairs(class) do
                info = Schema.voices.Get(c, text)
                if info then break end
            end

            if info then
                bFound = true

                if info.sound then
                    voiceList[#voiceList + 1] = {
                        global = info.global,
                        sound = info.sound
                    }
                end

                if k == 1 then
                    textTable[k] = info.text
                else
                    textTable[k] = string.lower(info.text)
                end

                if k != #textTable then
                    local endText = string.sub(info.text, -1)

                    if endText == '!' || endText == '?' then
                        textTable[k] = string.gsub(textTable[k], '[!?]$', ',')
                    end
                end
            end

            if not bFound and k != #textTable then
                textTable[k] = v .. '; '
            end
        end

        local str
        str = table.concat(textTable, ' ')
        str = string.gsub(str, ' ?([.?!]) (%l?)', fixMarkup)

        if voiceList[1] then
            local volume = 80

            if chatType == 'w' then
                volume = 45
            elseif chatType == 'y' then
                volume = 150
            end

            local delay = 0

            for k, v in ipairs(voiceList) do
                local sound = v.sound

                if istable(sound) then
                    sound = v.sound[1]
                end

                if delay == 0 then
                    speaker:EmitSound(sound, volume)
                    if radioChatTypes[chatType] then
                        for _, v in ipairs(player.GetAll()) do
                            if v:IsCombine() || v:IsCA() || v:IsDispatch() && not (v == speaker) then
                                if v:GetPos():DistToSqr( speaker:GetPos() ) < 50000 then continue end
                                net.Start('ixPlaySound')
                                    net.WriteString(sound)
                                    net.WriteInt(volume, 32)
                                net.Send(v)
                            end
                        end
                    end
                else
                    timer.Simple(delay, function()
                        speaker:EmitSound(sound, volume)
                        if radioChatTypes[chatType] then
                            for _, v in ipairs(player.GetAll()) do
                                if v:IsCombine() || v:IsCA() || v:IsDispatch() && not (v == speaker) then
                                    if v:GetPos():DistToSqr( speaker:GetPos() ) < 50000 then continue end
                                    net.Start('ixPlaySound')
                                        net.WriteString(sound)
                                        net.WriteInt(volume, 32)
                                    net.Send(v)
                                end
                            end
                        end
                    end)
                end

                if v.global then
                    if delay == 0 then
                        for k1, v1 in ipairs(receivers) do
                            if v1 != speaker then
                                net.Start('ixPlaySound')
                                    net.WriteString(sound)
                                    if isnumber(volume) then
                                        net.WriteInt(volume, 32)
                                    end
                                net.Send(v1)
                            end
                        end
                    else
                        timer.Simple(delay, function()
                            for k1, v1 in ipairs(receivers) do
                                if v1 != speaker then
                                    net.Start('ixPlaySound')
                                        net.WriteString(sound)
                                        if isnumber(volume) then
                                            net.WriteInt(volume, 32)
                                        end
                                    net.Send(v1)
                                end
                            end
                        end)
                    end
                end

                delay = delay + SoundDuration(sound) + 0.1
            end

            -- Play "off" sound only after the last voiceline has finished
            if speaker:IsCombine() then
                timer.Simple(delay + 0.5, function()
                    local offSound = offSounds[math.random(#offSounds)]
                    speaker:EmitSound(offSound, volume)
                end)
            end
        end

        str = str:sub(1, 1):upper() .. str:sub(2)
        if not validEnds[str:sub(-1)] then
            str = str .. '.'
        end

        if speaker:IsCombine() then
            return string.format('<:: %s ::>', str)
        else
            return str
        end
    end
end
