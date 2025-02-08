local PLUGIN = PLUGIN
PLUGIN.name = "Random Inspections and Rations"
PLUGIN.author = "OG Maker: Scotnay (Edited by Wade)"
PLUGIN.description = "Random events"
PLUGIN.events = {
    {
        name = "Workforce",
        start = function(bIsStart)
            if bIsStart then
                RunConsoleCommand("ix_curfew")
            end
        end,
        duration = 300,
        cooldown = 600
    },
    {
        name = "RATIONS",
        start = function(bIsStart)
            if bIsStart then
                RunConsoleCommand("ix_rations")
            end
        end,
        duration = 600,
        cooldown = 300
    },
}

PLUGIN.nextRationEvent = nil
PLUGIN.nextInspectionEvent = nil
SetGlobalBool("ixRationOnline", false)

function PLUGIN:GetEvent()
    local curTime = CurTime()
    if not self.nextRationEvent then
        self.nextRationEvent = curTime + self.events[2].cooldown
    end

    if not self.nextInspectionEvent then
        self.nextInspectionEvent = curTime + self.events[1].cooldown
    end

    local timeSinceRationEvent = curTime - self.nextRationEvent
    local timeSinceInspectionEvent = curTime - self.nextInspectionEvent

    if timeSinceInspectionEvent >= self.events[1].cooldown then
        if not self:IsEventActive() and ix.config.Get("cityCode") < 1 and self:GetNextEvent() == "Inspection" then
            local inspectionEvent = self.events[1]
            inspectionEvent.start(true)
            SetGlobalString("ixCurrentEvent", inspectionEvent.name)
            timer.Create(
                "InspectionTimer",
                inspectionEvent.duration,
                1,
                function()
                    inspectionEvent.start(false)
                    SetGlobalString("ixCurrentEvent", "PATROL, PROTECT")
                    self.nextInspectionEvent = curTime + inspectionEvent.cooldown
                end
            )
        end
    end

    if timeSinceRationEvent >= self.events[2].cooldown then
        if not self:IsEventActive() and ix.config.Get("cityCode") < 1 and self:GetNextEvent() == "Ration" then
            local rationEvent = self.events[2]
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

    -- Adjust the next event time if there is an ongoing event
    if self:IsEventActive() then
        if timeSinceInspectionEvent >= 0 then
            self.nextInspectionEvent = curTime + self.events[1].duration
        end

        if timeSinceRationEvent >= 0 then
            self.nextRationEvent = curTime + self.events[2].duration
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

function PLUGIN:GetNextEvent()
    if SERVER then
        local curTime = CurTime()
        if curTime >= self.nextInspectionEvent then
            return "Inspection"
        elseif curTime >= self.nextRationEvent then
            return "Ration"
        else
            return nil -- No event available yet
        end
    end
end

ix.util.Include("cl_hooks.lua")

if SERVER then
    util.AddNetworkString("DispatchMessage")

    local function SendDispatchMessageToAll(text, color)
        net.Start("DispatchMessage")
        net.WriteString(text)
        net.WriteColor(color or Color(189, 183, 107))
        net.Broadcast()
    end

    local function SendDispatchMessageToCombine(text, color)
        for _, ply in ipairs(player.GetAll()) do
            if ply:IsCombine() then
                net.Start("DispatchMessage")
                net.WriteString(text)
                net.WriteColor(color or Color(200, 50, 50))
                net.Send(ply)
            end
        end
    end

    ix.command.Add("Closerations", {
        description = "Close Rations",
        OnCheckAccess = function(_, ply) return ply:IsSuperAdmin() or ply:IsAdmin() or ply:IsGamemaster() end,
        OnRun = function(_, ply)
            SetGlobalBool("ixRationOnline", false)
        end
    })

    concommand.Add("ix_curfew", function(ply, cmd, args)
        if IsValid(ply) and (ply:IsSuperAdmin() or ply:IsAdmin() or ply:IsGamemaster()) or not IsValid(ply) then
            SetGlobalBool("ixRationOnline", false)

            SendDispatchMessageToCombine('Dispatch radios in "<:: Make sure all citizens are working. (FUck) ::>"')
        end
    end)

    concommand.Add("ix_rations", function(ply, cmd, args)
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
            end)
        end
    end)

    concommand.Add("ix_closerations", function(ply, cmd, args)
        if IsValid(ply) and (ply:IsSuperAdmin() or ply:IsAdmin() or ply:IsGamemaster()) or not IsValid(ply) then
            SetGlobalBool("ixRationOnline", false)
        end
    end)
else -- client
    net.Receive("DispatchMessage", function()
        local text = net.ReadString()
        local color = net.ReadColor()

        DispatchMessageData = {
            text = text,
            color = color,
            time = CurTime()
        }
    end)

    hook.Add("HUDPaint", "DrawDispatchMessage", function()
        if DispatchMessageData and DispatchMessageData.text then
            if CurTime() - DispatchMessageData.time < 12 then
                local scrW, scrH = ScrW(), ScrH()
                local x = scrW / 2
                local y = scrH - 100

                draw.SimpleText(DispatchMessageData.text, "RadioFont", x, y, DispatchMessageData.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            else
                DispatchMessageData = nil
            end
        end
    end)
end
