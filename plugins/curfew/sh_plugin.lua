local PLUGIN = PLUGIN
PLUGIN.name = "Random Inspections and Rations"
PLUGIN.author = "OG Maker: Scotnay (Edited by Wade)"
PLUGIN.description = "Random events"
PLUGIN.events = {
    { 
        name = "INSPECTION",
        start = function(bIsStart)
            if bIsStart then
                RunConsoleCommand("ix_curfew")
            end
        end,
        duration = 600,
        cooldown = 300
    },
    {
        name = "RATIONS",
        start = function(bIsStart)
            if bIsStart then
                RunConsoleCommand("ix_rations")
            end
        end,
        duration = 600,
        cooldown = 180
    },
}

PLUGIN.nextRationEvent = nil
PLUGIN.nextInspectionEvent = nil
PLUGIN.inspectionCounter = 0
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
            self.inspectionCounter = self.inspectionCounter + 1
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
                    self.inspectionCounter = 0
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
        local inspectionCount = self.inspectionCounter
        local number = math.random(1, 3)
        if inspectionCount < number then
            if curTime >= self.nextInspectionEvent then
                return "Inspection"
            else
                return nil
            end
            -- No event available yet
        else
            if curTime >= self.nextRationEvent then
                return "Ration"
            else
                return nil
            end
            -- No event available yet
        end
    end
end

ix.util.Include("cl_hooks.lua")
ix.command.Add(
    "Closerations",
    {
        description = "Close Rations",
        OnCheckAccess = function(_, ply) return ply:IsSuperAdmin() or ply:IsAdmin() or ply:IsGamemaster() end,
        OnRun = function(_, ply)
            SetGlobalBool("ixRationOnline", false)
            ix.chat.Send(ply, "adminchat", "Rations Closed", true)
        end
    }
)

ix.command.Add(
    "Curfew",
    {
        description = "Call the Curfew",
        OnCheckAccess = function(_, ply) return ply:IsSuperAdmin() or ply:IsAdmin() or ply:IsGamemaster() end,
        OnRun = function(_, ply)
            SetGlobalBool("ixRationOnline", false)
            PlayTimedEventSound(1, "npc/overwatch/cityvoice/f_trainstation_assemble_spkr.wav")
            local sounds = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/attention.wav", "npc/overwatch/radiovoice/_comma.wav", "npc/overwatch/radiovoice/search.wav", "npc/overwatch/radiovoice/inprogress.wav", "npc/overwatch/radiovoice/_comma.wav", "npc/overwatch/radiovoice/preparetoinnoculate.wav", "npc/overwatch/radiovoice/off2.wav"}
            for _, v in ipairs(player.GetAll()) do
                if v:IsCombine() then
                    ix.util.EmitQueuedSounds(v, sounds, 0, 0.2, 100)
                end
            end

            ix.chat.Send(ply, "dispatchradio", "Attention, city-wide block search in progress. All local Protection Team units: prepare to inoculate.")
            ix.chat.Send(ply, "dispatch", "Citizen notice: priority identification check in progress. Please assemble in your designated inspection positions.")
        end
    }
)

concommand.Add(
    "ix_curfew",
    function(ply, cmd, args, client)
        if ply:IsSuperAdmin() or ply:IsAdmin() or ply:IsGamemaster() then
            SetGlobalBool("ixRationOnline", false)
            PlayTimedEventSound(4, "npc/overwatch/cityvoice/f_trainstation_assemble_spkr.wav")
            local sounds = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/attention.wav", "npc/overwatch/radiovoice/_comma.wav", "npc/overwatch/radiovoice/search.wav", "npc/overwatch/radiovoice/inprogress.wav", "npc/overwatch/radiovoice/_comma.wav", "npc/overwatch/radiovoice/preparetoinnoculate.wav", "npc/overwatch/radiovoice/off2.wav"}
            for _, v in ipairs(player.GetAll()) do
                if v:IsCombine() then
                    ix.util.EmitQueuedSounds(v, sounds, 0, 0.2, 100)
                end
            end

            ix.chat.Send(ply, "dispatchradio", "Attention, city-wide block search in progress. All local Protection Team units: prepare to inoculate.")
            timer.Simple(
                4,
                function()
                    ix.chat.Send(ply, "dispatch", "Citizen notice: priority identification check in progress. Please assemble in your designated inspection positions.")
                end
            )
        end
    end
)

concommand.Add(
    "ix_rations",
    function(ply, cmd, args)
        if ply:IsSuperAdmin() or ply:IsAdmin() or ply:IsGamemaster() then
            SetGlobalBool("ixRationOnline", true)
            PlayTimedEventSound(4, "ambient/alarms/warningbell1.wav")
            PlayTimedEventSound(6, "ambient/alarms/warningbell1.wav")
            PlayTimedEventSound(8, "ambient/alarms/warningbell1.wav")
            local sounds = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/attention.wav", "npc/overwatch/radiovoice/allunitsat.wav", "npc/overwatch/radiovoice/distributionblock.wav", "npc/overwatch/radiovoice/respond.wav", "npc/overwatch/radiovoice/off2.wav"}
            for _, v in ipairs(player.GetAll()) do
                if v:IsCombine() then
                    ix.util.EmitQueuedSounds(v, sounds, 0, 0.2, 100)
                end
            end

            ix.chat.Send(ply, "dispatchradio", "Attention Units, Ration Protocol is now active, Respond.")
        end
    end
)

concommand.Add(
    "ix_closerations",
    function(ply, cmd, args)
        if ply:IsSuperAdmin() or ply:IsAdmin() or ply:IsGamemaster() then
            SetGlobalBool("ixRationOnline", false)
            ix.chat.Send(ply, "adminchat", "Rations Closed", true)
        end
    end
)