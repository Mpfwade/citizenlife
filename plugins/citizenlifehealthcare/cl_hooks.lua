local PLUGIN = PLUGIN or {}

local moodleSize = 64 -- Add more moodles here as needed
local screenMargin = 10
function PLUGIN:UpdateMoodlePositions()
    local activeCount = 0
    for _, moodle in pairs(self.moodles) do
        if moodle.isActive then
            moodle.targetPosition = ScrW() - screenMargin - (moodleSize + screenMargin) * (activeCount + 1)
            activeCount = activeCount + 1
        else
            moodle.targetPosition = ScrW() + moodleSize -- Off-screen
        end
    end
end

function PLUGIN:HUDPaint()
    self:UpdateMoodlePositions()
    for _, moodle in pairs(self.moodles) do
        moodle.position = Lerp(0.05, moodle.position, moodle.targetPosition) -- Animate moodle position
        if moodle.isActive then -- Draw moodle if active
            surface.SetMaterial(moodle.material)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(moodle.position, screenMargin, moodleSize, moodleSize)
        end
    end
end

hook.Add("HUDPaint", "MoodleHUDPaint", function() PLUGIN:HUDPaint() end)

function PLUGIN:RenderScreenspaceEffects() -- Render screen effects
    local character = LocalPlayer():GetCharacter()
    if LocalPlayer():IsCombine() then return end  -- Skip effects for Combine players.
    if character then
        local drunkEffect = character:GetDrunkEffect()
        local sicknessLevel = character:GetData("sickness", 0)

        -- Handle drunk effects
        if drunkEffect and drunkEffect > 0 then
            DrawMotionBlur(0.075, drunkEffect, 0.025)
        end

        -- Handle specific water effect
        if character:GetData("Water", false) then
            DrawSharpen(5, 5)
        end

        -- Adjust motion blur based on sickness level
        if sicknessLevel >= 89 then
            -- Apply strong motion blur for high sickness levels
            DrawMotionBlur(0.1, 0.4, 0.01)
            DrawColorModify({
                ["$pp_colour_addr"] = 0,
                ["$pp_colour_addg"] = 0,
                ["$pp_colour_addb"] = 0,
                ["$pp_colour_brightness"] = 0,
                ["$pp_colour_contrast"] = 1,
                ["$pp_colour_colour"] = 0, -- Reduce the color saturation to zero for grayscale
                ["$pp_colour_mulr"] = 0,
                ["$pp_colour_mulg"] = 0,
                ["$pp_colour_mulb"] = 0
            })
        elseif sicknessLevel > 49 then
            -- Apply moderate motion blur for medium sickness levels
            DrawMotionBlur(0.1, 0.3, 0.01)
        elseif sicknessLevel > 14 then
            -- Apply mild motion blur for mild sickness levels
            DrawMotionBlur(0.1, 0.1, 0.01)
        else
            -- No motion blur when sickness level is below 15
            DrawMotionBlur(0, 0, 0)
        end
    end
end

function PLUGIN:GetWarmthText(amount)
    if amount > 75 then
        return L("warmthWarm")
    elseif amount > 50 then
        return L("warmthChilly")
    elseif amount > 25 then
        return L("warmthCold")
    else
        return L("warmthFreezing")
    end
end

function PLUGIN:WarmthEnabled()
    ix.bar.Add(function()
        local character = LocalPlayer():GetCharacter()
        if character then
            local warmth = character:GetWarmth()
            return warmth / 100, self:GetWarmthText(warmth)
        end
        return false
    end, Color(200, 50, 40), nil, "warmth")
end

function PLUGIN:WarmthDisabled()
    ix.bar.Remove("warmth")
end

function PLUGIN:StopEffects()
    -- Reset motion blur to none
    DrawMotionBlur(0, 0, 0)

    -- Reset color modifications if any
    DrawColorModify({
        ["$pp_colour_addr"] = 0,
        ["$pp_colour_addg"] = 0,
        ["$pp_colour_addb"] = 0,
        ["$pp_colour_brightness"] = 0,
        ["$pp_colour_contrast"] = 1,
        ["$pp_colour_colour"] = 1,
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 0,
        ["$pp_colour_mulb"] = 0
    })

    -- Reset all moodles
    if PLUGIN.SetMoodleActive then
        PLUGIN:SetMoodleActive("sick", false)
        PLUGIN:SetMoodleActive("moresick", false)
        PLUGIN:SetMoodleActive("bored", false)
        PLUGIN:SetMoodleActive("unhappy", false)
        PLUGIN:SetMoodleActive("panic", false)
        PLUGIN:SetMoodleActive("weak", false)
        PLUGIN:SetMoodleActive("moreweak", false)
        PLUGIN:SetMoodleActive("stam", false)
        PLUGIN:SetMoodleActive("stressed", false)
        PLUGIN:SetMoodleActive("hungry", false)
        PLUGIN:SetMoodleActive("terrified", false)
    end

    -- Reset specific data on the character if needed
    local char = LocalPlayer():GetCharacter()
    if char and IsValid(char) then
        char:SetData("sickness", 0)
        char:SetData("sicknessType", "none")
        char:SetData("IsPanicked", false)
        char:SetData("sickness_immunity", nil)  -- Reset immunity if applicable
    end
end

hook.Add("PlayerDeath", "StopEffects", function(ply)
    if ply == LocalPlayer() then
        PLUGIN:StopEffects()
    end
end)

net.Receive("TriggerScreenShake", function()
    local duration = net.ReadFloat()
    local intensity = net.ReadFloat()
    local radius = net.ReadFloat()
    local viewpunchVec = net.ReadVector()
    local viewpunchAng = Angle(viewpunchVec.x, viewpunchVec.y, viewpunchVec.z) -- Convert the Vector to an Angle
    LocalPlayer():SetViewPunchAngles(viewpunchAng)
    util.ScreenShake(LocalPlayer():GetPos(), intensity, 5, duration, radius)
end)

net.Receive("MoodlesIcons", function()
    local char = LocalPlayer():GetCharacter()
    if not char then return end

    if char:GetHunger() <= 49 then
        PLUGIN:SetMoodleActive("hungry", true)
    else
        PLUGIN:SetMoodleActive("hungry", false)
    end

    local sicknessLevel = char:GetData("sickness", 0)

    if sicknessLevel > 49 then
        if PLUGIN.SetMoodleActive then  -- Check if function exists
            PLUGIN:SetMoodleActive("moresick", true)
            PLUGIN:SetMoodleActive("sick", false)
        end
    elseif sicknessLevel > 14 then
        if PLUGIN.SetMoodleActive then
            PLUGIN:SetMoodleActive("sick", true)
            PLUGIN:SetMoodleActive("moresick", false)
        end
    else
        if PLUGIN.SetMoodleActive then
            PLUGIN:SetMoodleActive("sick", false)
            PLUGIN:SetMoodleActive("moresick", false)
        end
    end

    local currentSanity = char:GetSanity()

    -- Reset all moodles first
    PLUGIN:SetMoodleActive("bored", false)
    PLUGIN:SetMoodleActive("unhappy", false)
    PLUGIN:SetMoodleActive("panic", false)

    -- Check conditions and set the highest priority moodle active
    if currentSanity <= 14 then
        PLUGIN:SetMoodleActive("panic", true)  -- Most severe condition
    elseif currentSanity <= 44 then
        PLUGIN:SetMoodleActive("unhappy", true)  -- Moderate condition
    elseif currentSanity <= 64 then
        PLUGIN:SetMoodleActive("bored", true)  -- Least severe condition
    end

    local currentStress = char:GetStress()

     -- Reset all moodles first
    PLUGIN:SetMoodleActive("stressed", false)
    PLUGIN:SetMoodleActive("terrified", false)

    -- Check conditions and set the highest priority moodle active
    if currentStress > 50 then
        PLUGIN:SetMoodleActive("terrified", true)
    elseif currentStress > 25 then
        PLUGIN:SetMoodleActive("stressed", true)
    end

    local weakness = char:GetData("weakness", 0)

    PLUGIN:SetMoodleActive("weak", false)
    PLUGIN:SetMoodleActive("moreweak", false)

    if weakness > 50 then
        PLUGIN:SetMoodleActive("moreweak", true)
    elseif weakness > 25 then
        PLUGIN:SetMoodleActive("weak", true)
    end

    local stamina = LocalPlayer():GetLocalVar("stm", 100)

    PLUGIN:SetMoodleActive("stam", false)

    if stamina < 25 then
        PLUGIN:SetMoodleActive("stam", true)
    end
end)

net.Receive("TriggerPukeEffect", function()
    local ply = net.ReadEntity()
    if IsValid(ply) then
        local mouthAttachment = ply:LookupAttachment("mouth")
        if mouthAttachment then
            local attachmentInfo = ply:GetAttachment(mouthAttachment)
            if attachmentInfo then
                local pos = attachmentInfo.Pos
                local ang = attachmentInfo.Ang
                local effectData = EffectData()
                effectData:SetOrigin(pos)
                effectData:SetAngles(ang)
                effectData:SetScale(5)
                effectData:SetColor(0)
                effectData:SetFlags(3)
                util.Effect("bloodspray", effectData)
            end
        end
    end
end)

local currentSanityound = nil

net.Receive("PlayClientSound", function()
    local soundFile = net.ReadString()
    print("Received request to play sound:", soundFile)  -- Debug output

    if currentSanityound then
        currentSanityound:Stop()
        print("Stopping current sound")  -- Debug output
    end
    
    currentSanityound = CreateSound(LocalPlayer(), soundFile)
    if currentSanityound then
        currentSanityound:Play()
        print("Playing new sound")  -- Debug output
    else
        print("Failed to create sound with file:", soundFile)  -- Debug output
    end
end)

net.Receive("StopClientSound", function()
    if currentSanityound then
        currentSanityound:Stop()
        currentSanityound = nil
        print("Stopped sound via network message")  -- Debug output
    end
end)

hook.Add("PlayerDeath", "StopSoundOnDeath", function(ply)
    if ply == LocalPlayer() and currentSanityound then
        currentSanityound:Stop()
        currentSanityound = nil
        print("Sound stopped on death")  -- Debug output
    end
end)