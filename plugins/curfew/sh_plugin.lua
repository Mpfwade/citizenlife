local PLUGIN = PLUGIN
PLUGIN.name = "Random Rations"
PLUGIN.author = "OG Maker: Scotnay (Edited by Wade)"
PLUGIN.description = "Random ration events"

PLUGIN.events = {
    {
        name = "RATIONS",
        start = function(bIsStart)
            if bIsStart then
                RunConsoleCommand("ix_rations")
            end
        end,
        duration = 600,
        cooldown = 300 -- 15 minutes
    }
}

PLUGIN.nextRationEvent = nil
SetGlobalBool("ixRationOnline", false)

function PLUGIN:GetEvent()
    local curTime = CurTime()

    if not self.nextRationEvent then
        self.nextRationEvent = curTime + self.events[1].cooldown
    end

    local timeSinceRationEvent = curTime - self.nextRationEvent

    if timeSinceRationEvent >= self.events[1].cooldown then
        if not self:IsEventActive() and ix.config.Get("cityCode") < 1 then
            local rationEvent = self.events[1]
            rationEvent.start(true)
            SetGlobalString("ixCurrentEvent", rationEvent.name)
            timer.Create(
                "RationTimer",
                rationEvent.duration,
                1,
                function()
                    rationEvent.start(false)
                    SetGlobalString("ixCurrentEvent", "PATROL, PROTECT")
                    self.nextRationEvent = curTime + rationEvent.cooldown
                end
            )
        end
    end

    if self:IsEventActive() then
        if timeSinceRationEvent >= 0 then
            self.nextRationEvent = curTime + self.events[1].duration
        end
    end

    if ix.config.Get("cityCode") > 0 then
        SetGlobalString("ixCurrentEvent", "PATROL, PROTECT")
    end

    return GetGlobalString("ixCurrentEvent", "PATROL, PROTECT")
end

function PLUGIN:Think()
    self:GetEvent()
end

function PLUGIN:IsEventActive()
    local currentEvent = GetGlobalString("ixCurrentEvent", "PATROL, PROTECT")
    for _, event in ipairs(self.events) do
        if event.name == currentEvent then return true end
    end

    return false
end

function PLUGIN:Initialize()
    hook.Add(
        "Think",
        "RandomEventThink",
        function()
            self:Think()
        end
    )
end

ix.util.Include("cl_hooks.lua")

if SERVER then
    util.AddNetworkString("DispatchMessage")

    local function SendDispatchMessageToAll(text, color)
        net.Start("DispatchMessage")
        net.WriteString(text)
        net.WriteColor(color or Color(189, 183, 107)) -- Default color
        net.Broadcast() -- Sends to all players
    end

    local function SendDispatchMessageToCombine(text, color)
        for _, ply in ipairs(player.GetAll()) do
            if ply:IsCombine() then
                net.Start("DispatchMessage")
                net.WriteString(text)
                net.WriteColor(color or Color(200, 50, 50)) -- Default color for Combine
                net.Send(ply)
            end
        end
    end

    ix.command.Add(
        "Closerations",
        {
            description = "Close Rations",
            OnCheckAccess = function(_, ply) return ply:IsSuperAdmin() or ply:IsAdmin() or ply:IsGamemaster() end,
            OnRun = function(_, ply)
                SetGlobalBool("ixRationOnline", false)
            end
        }
    )

    concommand.Add(
        "ix_rations",
        function(ply, cmd, args)
            if IsValid(ply) and (ply:IsSuperAdmin() or ply:IsAdmin() or ply:IsGamemaster()) or not IsValid(ply) then
                PlayTimedEventSound(4, "ambient/alarms/warningbell1.wav")
                PlayTimedEventSound(6, "ambient/alarms/warningbell1.wav")
                PlayTimedEventSound(8, "ambient/alarms/warningbell1.wav")
                local sounds = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/attention.wav", "npc/overwatch/radiovoice/allunitsat.wav", "npc/overwatch/radiovoice/distributionblock.wav", "npc/overwatch/radiovoice/respond.wav", "npc/overwatch/radiovoice/off2.wav"}
                for _, v in ipairs(player.GetAll()) do
                    if v:IsCombine() then
                        ix.util.EmitQueuedSounds(v, sounds, 0, 0.2, 100)
                    end
                end

                SendDispatchMessageToCombine('Dispatch radios in "<:: Attention units, Ration Protocol is now active, respond. ::>"')

                timer.Simple(180, function()
                    SetGlobalBool("ixRationOnline", true)
                    SendDispatchMessageToCombine('Dispatch radios in "<:: Attention units, Rations are now open. ::>"')
                    PlayTimedEventSound(1, "ambient/alarms/warningbell1.wav")
                end)
            end
        end
    )

    concommand.Add(
        "ix_closerations",
        function(ply, cmd, args)
            if IsValid(ply) and (ply:IsSuperAdmin() or ply:IsAdmin() or ply:IsGamemaster()) or not IsValid(ply) then
                SetGlobalBool("ixRationOnline", false)
                local messageSender = IsValid(ply) and ply or nil
            end
        end
    )
else -- client
    net.Receive("DispatchMessage", function()
        local text = net.ReadString()
        local color = net.ReadColor()

        -- Store the message and its properties
        DispatchMessageData = {
            text = text,
            color = color,
            time = CurTime() -- To keep track of when the message was received
        }
    end)

    hook.Add("HUDPaint", "DrawDispatchMessage", function()
        if DispatchMessageData and DispatchMessageData.text then
            if CurTime() - DispatchMessageData.time < 12 then -- Display message for 12 seconds
                local scrW, scrH = ScrW(), ScrH()
                local x = scrW / 2 -- Horizontally centered
                local y = scrH - 100 -- Positioned 100 pixels from the bottom

                draw.SimpleText(DispatchMessageData.text, "RadioFont", x, y, DispatchMessageData.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            else
                DispatchMessageData = nil -- Clear the data after 12 seconds
            end
        end
    end)
end
