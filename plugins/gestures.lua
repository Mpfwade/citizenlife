local PLUGIN = PLUGIN

PLUGIN.name = "Player Gestures"
PLUGIN.description = "Adds gestures that can be used for certain supported animations. Major thanks to Wicked Rabbit for showing me how it works!"
PLUGIN.author = "Riggs Mackay (Edited by Wade)"
PLUGIN.schema = "Any"
PLUGIN.license = [[
Copyright 2022 Riggs Mackay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

PLUGIN.gestures = { -- Mainly for the citizen_male models, or models that include the citizen male gestures
    -- citizen rp go brrrr...
    {gesture = "g_salute", command = "Salute", id = 1444},
    {gesture = "g_antman_dontmove", command = "DontMove", id = 1445},
    {gesture = "g_antman_stayback", command = "StayBack", id = 1446},
    {gesture = "g_armsout", command = "ArmSout", id = 1447},
    {gesture = "g_armsout_high", command = "ArmSoutHigh", id = 1448},
    {gesture = "g_chestup", command = "ChestUp", id = 1449},
    {gesture = "g_clap", command = "Clap", id = 1450},
    {gesture = "g_fist_L", command = "FistLeft", id = 1451},
    {gesture = "g_fist_r", command = "FistRight", id = 1452},
    {gesture = "g_fist_swing_across", command = "FistSwing", id = 1453},
    {gesture = "g_fistshake", command = "FistShake", id = 1454},
    {gesture = "g_frustrated_point_l", command = "PointFrustrated", id = 1455},
    {gesture = "G_noway_big", command = "No", id = 1456},
    {gesture = "G_noway_small", command = "NoSmall", id = 1457},
    {gesture = "g_plead_01", command = "Plead", id = 1458},
    {gesture = "g_point", command = "Point", id = 1459},
    {gesture = "g_point_swing", command = "PointSwing", id = 1460},
    {gesture = "g_pointleft_l", command = "PointLeft", id = 1461},
    {gesture = "g_pointright_l", command = "PointRight", id = 1462},
    {gesture = "g_present", command = "Present", id = 1463},
    {gesture = "G_shrug", command = "Shrug", id = 1464},
    {gesture = "g_thumbsup", command = "ThumbsUp", id = 1465},
    {gesture = "g_wave", command = "Wave", id = 1466},
    {gesture = "G_what", command = "What", id = 1467},
    {gesture = "hg_headshake", command = "HeadShake", id = 1468},
    {gesture = "hg_nod_no", command = "HeadNo", id = 1469},
    {gesture = "hg_nod_yes", command = "HeadYes", id = 1470},
    {gesture = "hg_nod_left", command = "HeadLeft", id = 1471},
    {gesture = "hg_nod_right", command = "HeadRight", id = 1472},
    {gesture = "GestureButton", command = "Button", id = 1473},


    --{gesture = "hg_nod_right", command = "HeadRight", id = 1473},
}

if (SERVER) then
-- Don't bother DMing me to add female variants, do it yourself.

function PLUGIN:DoAnimationEvent(player, event, data)
    if event == PLAYERANIMEVENT_CUSTOM_GESTURE then
        for _, gesture in pairs(self.gestures) do
            if data == gesture.id then
                if player.isAnimating then return end
                net.Start("PlayerGesture")
                net.WriteEntity(player)
                net.WriteUInt(gesture.id, 16) -- Use 16 bits to send the gesture ID
                net.Broadcast()

                -- Apply the gesture to the initiating player
                player:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, player:LookupSequence(gesture.gesture), 0, true)
                player.isAnimating = true

                -- Reset the animation state after the duration of the animation
                timer.Simple(player:SequenceDuration(), function()
                    if IsValid(player) then
                        player.isAnimating = false
                    end
                end)

                return ACT_INVALID
            end
        end
    end
end

for k, v in pairs(PLUGIN.gestures) do
    local commandname = string.Replace(v.gesture, "hg_", "")
    commandname = string.Replace(commandname, "g_", "")
    commandname = string.Replace(commandname, "antman_", "")
    commandname = string.Replace(commandname, "_", " ")

    concommand.Add("ix_act_"..v.command, function(ply, cmd, args)
        if ply.isAnimating then return end -- Prevent playing a new animation if one is already active
        ply:DoAnimationEvent(v.id)
    end)

    ix.command.Add("Gesture"..v.command, {
        description = "Play the "..commandname.." gesture.",
        OnCanRun = function(_, ply)
            if ply:IsFemale() then
                return "Female variants are not supported."
            end
            if not ply:IsSuperAdmin() or ply:IsAdmin() then
                return "You need to be an admin!"
            end
        end,
        OnRun = function(_, ply)
            if ( SERVER ) then
                ply:ConCommand("ix_act_"..v.command)
            end
        end
    })
end

    util.AddNetworkString("PlayerGesture")

    local allowedChatTypes = {
        ["ic"] = true,
        ["w"] = true,
        ["y"] = true,
    }

    local RandomAnims = {"ix_act_armsout", "ix_act_no", "ix_act_nosmall", "ix_act_plead", "ix_act_point", "ix_act_chestup", "ix_act_fistleft", "ix_act_present", "ix_act_headleft", "ix_act_headright"}
    local WhatAnims = {"ix_act_what", "ix_act_shrug"}
    function PLUGIN:PrePlayerMessageSend(ply, chatType, message, bAnonymous)
        if ( allowedChatTypes[chatType] ) then
            if ( message:find("!") ) then
                ply:ConCommand("ix_act_fistswing")
            elseif ( message:find("?") ) then
                ply:ConCommand( table.Random( WhatAnims ) )
            elseif ( message:find( "Nice" ) ) then
                ply:ConCommand("ix_act_thumbsup")
            elseif ( message:find("YAY") or message:find("Hooray") or message:find("Bravo") ) then
                ply:ConCommand("ix_act_clap")
            elseif ( message:find("Mhm") ) then
                ply:ConCommand("ix_act_headyes")
            elseif ( message:find("Stay down") or message:find("Get down!") or message:find("Get down") or message:find("Take cover!") or message:find("Take cover") ) then
                ply:ConCommand("ix_act_dontmove")
            elseif ( message:find(".")) then
                ply:ConCommand( table.Random( RandomAnims ) )
            end
        end
    end
end

if CLIENT then
    net.Receive("PlayerGesture", function()
        local player = net.ReadEntity()
        local gestureId = net.ReadUInt(16)
    
        if IsValid(player) and not player.isAnimating then
            for _, gesture in pairs(PLUGIN.gestures) do
                if gestureId == gesture.id then
                    -- Apply the gesture to the player
                    player:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, player:LookupSequence(gesture.gesture), 0, true)
                    player.isAnimating = true
    
                    -- Reset the animation state after the duration
                    timer.Simple(player:SequenceDuration(), function()
                        if IsValid(player) then
                            player.isAnimating = false
                        end
                    end)
    
                    break
                end
            end
        end
    end)
end