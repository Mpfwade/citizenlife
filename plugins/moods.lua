local PLUGIN = PLUGIN or {}
PLUGIN.name = "Emote Moods"
PLUGIN.author = "DrodA (Ported from NS)"
PLUGIN.description = "With this plugin, characters can set their mood."
PLUGIN.schema = "Any"
PLUGIN.version = 1.2
MOOD_NONE = 0
MOOD_RELAXED = 1
MOOD_FRUSTRATED = 2
MOOD_MODEST = 3
MOOD_COWER = 4

PLUGIN.MoodTextTable = {
    [MOOD_NONE] = "Default",
    [MOOD_RELAXED] = "Relaxed",
    [MOOD_FRUSTRATED] = "Frustrated",
    [MOOD_MODEST] = "Modest",
    [MOOD_COWER] = "Cower",
}

PLUGIN.MoodBadMovetypes = {
    [MOVETYPE_FLY] = true,
    [MOVETYPE_LADDER] = true,
    [MOVETYPE_NOCLIP] = true
}

PLUGIN.MoodAnimTable = {
    [MOOD_RELAXED] = {
        [0] = "LineIdle01",
        [1] = "walk_all_Moderate",
        [2] = "run_all"
    },
    [MOOD_FRUSTRATED] = {
        [0] = "LineIdle02",
        [1] = "pace_all",
        [2] = "run_all"
    },
    [MOOD_MODEST] = {
        [0] = "LineIdle04",
        [1] = "plaza_walk_all",
        [2] = "run_all"
    },
    [MOOD_COWER] = {
        [0] = "cower_Idle",
        [1] = "plaza_walk_all",
        [2] = "ACT_RUN_PROTECTED"
    }
}

do
    local meta = FindMetaTable("Player")

    function meta:GetMood()
        return self:GetNetVar("mood") or MOOD_NONE
    end

    if SERVER then
        function meta:SetMood(int)
            int = int or 0
            self:SetNetVar("mood", int)
        end
    end
end

if SERVER then
    function PLUGIN:PlayerLoadedCharacter(client, character)
        client:SetMood(MOOD_NONE)
    end
end

do
    local COMMAND = {}
    COMMAND.description = "Set your own mood"

    COMMAND.arguments = {ix.type.number}

    COMMAND.adminOnly = false

    function COMMAND:OnRun(client, mood)
        mood = math.Clamp(mood, 0, MOOD_COWER)
        client:SetMood(mood)
    end

    ix.command.Add("Mood", COMMAND)

    local tblWorkaround = {
        ["ix_keys"] = true,
        ["ix_hands"] = true,
        ["ix_stunstick"] = true
    }

    function PLUGIN:CalcMainActivity(client, velocity)
        local length = velocity:Length2DSqr()
        local clientInfo = client:GetTable()
        local mood = client:GetMood()

        if client and IsValid(client) and client:IsPlayer() then
            if not client:IsWepRaised() and not client:Crouching() and IsValid(client:GetActiveWeapon()) and tblWorkaround[client:GetActiveWeapon():GetClass()] and not client:InVehicle() and mood > 0 and not self.MoodBadMovetypes[client:GetMoveType()] and not client.m_bJumping and client:IsOnGround() then
                if length < 0.25 then
                    clientInfo.CalcSeqOverride = self.MoodAnimTable[mood][0] and client:LookupSequence(self.MoodAnimTable[mood][0]) or clientInfo.CalcSeqOverride
                elseif length > 0.25 and length < 22500 then
                    clientInfo.CalcSeqOverride = self.MoodAnimTable[mood][1] and client:LookupSequence(self.MoodAnimTable[mood][1]) or clientInfo.CalcSeqOverride
                elseif length > 22500 then
                    client.CalcSeqOverride = self.MoodAnimTable[mood][2] and client:LookupSequence(self.MoodAnimTable[mood][2]) or clientInfo.CalcSeqOverride
                end
            end
        end
    end
end

do
    if SERVER then
        local cooldown = 1 -- Adjust the cooldown duration here (in seconds)
        local cooldowns = {}

        function PLUGIN:PlayerButtonDown(client, button)
            local char = client:GetCharacter()

            local tblWorkaround = {
                ["ix_keys"] = true,
                ["ix_hands"] = true,
            }

            if button == MOUSE_MIDDLE and IsValid(client:GetActiveWeapon()) and tblWorkaround[client:GetActiveWeapon():GetClass()] and char then
                local currentMood = client:GetMood()
                local nextMood = currentMood + 1

                if nextMood > MOOD_COWER then
                    nextMood = MOOD_NONE
                end

                if not cooldowns[client] or CurTime() >= cooldowns[client] then
                    cooldowns[client] = CurTime() + cooldown
                    client:SetMood(nextMood)

                    timer.Simple(0.15, function()
                        client:ChatPrint("You have changed your mood to " .. PLUGIN.MoodTextTable[client:GetMood()] .. ".")
                    end)
                else
                    return
                end
            end
        end
    end
end
