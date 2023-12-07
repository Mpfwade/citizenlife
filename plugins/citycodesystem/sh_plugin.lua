local PLUGIN = PLUGIN
PLUGIN.name = "City Codes"
PLUGIN.author = "Riggs Mackay"
PLUGIN.description = "City Codes for Lite Network, used from Overlord Community."
ix.util.Include("sv_plugin.lua")

ix.cityCodes = {
    [0] = {"PRESERVED", Color(0, 138, 216), "Civil"},
    [1] = {"MARGINAL", Color(223, 195, 33), "Civil Unrest"},
    [2] = {"FRACTURED", Color(128, 0, 0), "City Turmoil"},
    [3] = {"RE-ADMINISTRATION IN PROGRESS", Color(150, 150, 150), "Judgement Waiver"},
    [4] = {"CODE VOID", Color(50, 50, 50), "Autonomous Judgement"},
}

local cityCodes = {
    ["blue"] = 0,
    ["yellow"] = 1,
    ["red"] = 2,
    ["white"] = 3,
    ["gray"] = 4,
}

ix.command.Add("ChangeCityCode", {
    description = "Change the current civic politistabilization index. (blue, yellow, red, white, gray)",
    syntax = ix.type.string,
    OnRun = function(self, ply, status)
        if not (ply:IsCombineCommand() or ply:IsAdmin() or ply:IsGamemaster() or ply:IsMod() or ply:IsDispatch()) then
            ply:Notify("You can't change the city codes, only commanders can do it.")

            return false
        end

        for code, id in pairs(cityCodes) do
            if status[1] == code then
                ix.config.Set("cityCode", id)
            end
        end

        -- Judgement Waiver
        if status[1] == "white" then
            if not (GetGlobalBool("ixJWStatus") == true) then
                PLUGIN:JudgementWaiverStart()

                if GetGlobalBool("ixCTStatus") == true then
                    PLUGIN:CityTurmoilStop()
                end

                if GetGlobalBool("ixAJStatus") == true then
                    timer.Simple(10, function()
                        PLUGIN:AutonomousJudgementStop()
                    end)
                end
            end
        elseif status[1] == "gray" then
            -- Autonomous Judgement
            if GetGlobalBool("ixJWStatus") == true then
                PLUGIN:JudgementWaiverStopSilent()
            end

            if GetGlobalBool("ixCTStatus") == true then
                PLUGIN:CityTurmoilStop()
            end

            if not (GetGlobalBool("ixAJStatus") == true) then
                PLUGIN:AutonomousJudgementStart()
            end
        elseif status[1] == "red" then
            -- City Turmoil
            if not (GetGlobalBool("ixCTStatus") == true) then
                PLUGIN:CityTurmoilStart()

                if GetGlobalBool("ixJWStatus") == true then
                    PLUGIN:JudgementWaiverStop()
                end

                if GetGlobalBool("ixAJStatus") == true then
                    timer.Simple(10, function()
                        PLUGIN:AutonomousJudgementStop()
                    end)
                end
            end
        elseif status[1] == "yellow" then
            -- City Unrest
            if not (GetGlobalBool("ixCUStatus") == true) then
                PLUGIN:CivilUnrestStart()

                if GetGlobalBool("ixJWStatus") == true then
                    PLUGIN:JudgementWaiverStop()
                end

                if GetGlobalBool("ixCTStatus") == true then
                    PLUGIN:CityTurmoilStop()
                end

                if GetGlobalBool("ixAJStatus") == true then
                    timer.Simple(10, function()
                        PLUGIN:AutonomousJudgementStop()
                    end)
                end
            end
        else -- Disable Everything if it is on..
            if GetGlobalBool("ixJWStatus") == true then
                PLUGIN:JudgementWaiverStop()
            end

            if GetGlobalBool("ixAJStatus") == true then
                PLUGIN:AutonomousJudgementStop()
            end

            if GetGlobalBool("ixCTStatus") == true then
                PLUGIN:CityTurmoilStop()
            end

            if GetGlobalBool("ixCUStatus") == true then
                PLUGIN:CivilUnrestStop()
            end
        end
    end
})

local ccaDeaths = 0
local ccaDeathTimer

local function StartCivilUnrest()
    ix.config.Set("cityCode", 1)
    PLUGIN:CivilUnrestStart()
end

local function StopCivilUnrest()
    ix.config.Set("cityCode", 0)
    PLUGIN:CivilUnrestStop()
    ccaDeaths = 0
    ccaDeathTimer = nil
end

function PLUGIN:PlayerDeath(victim, inflictor, attacker)
    if victim:Team() == FACTION_CCA then
        ccaDeaths = ccaDeaths + 1

        if not ccaDeathTimer and ix.config.Get("cityCode", 0) == 0 then
            StartCivilUnrest()
            ccaDeathTimer = timer.Create("CCADEATHCHECK", 10, 1, StopCivilUnrest)
        end
    end
end

timer.Create("CCADEATHCHECK", 10, 0, function()
    if ccaDeaths == 0 and ccaDeathTimer and ix.config.Get("cityCode", 1) == 1 then
        StopCivilUnrest()
    end
end)

local traumaThreshold = 3 -- The number of times a player needs to be hurt to trigger a city code change
local traumaCooldown = 15 -- The cooldown (in seconds) between trauma notifications
local playerTrauma = {}

function PLUGIN:PlayerHurt(ply, attacker, health, damage)
    if ply:Team() ~= FACTION_CCA then return end

    if not playerTrauma[ply] then
        playerTrauma[ply] = 0
    end

    if ix.config.Get("cityCode", 0) == 0 then
    playerTrauma[ply] = playerTrauma[ply] + 1
    end

    if playerTrauma[ply] >= traumaThreshold and ix.config.Get("cityCode", 0) == 0 and not ccaDeathTimer then
        playerTrauma[ply] = 0
        StartCivilUnrest()
    end

    local name = string.upper(ply:Nick() or "unknown unit")
    local text = "EXTERNAL"

    if damage > 15 then
        text = "SEVERE"
        Schema:AddWaypoint(ply:GetPos() + Vector(0, 0, 30), "UNIT " .. name .. " RECEIVED " .. text .. " TRAUMA...", Color(200, 100, 0), 120, ply)
    end

    Schema:AddCombineDisplayMessage("WARNING! UNIT " .. name .. " RECEIVED " .. text .. " TRAUMA...", Color(255, 0, 0, 255), text)

    if health < 30 then
        ply:AddCombineDisplayMessage("WARNING! VITAL SIGNS DROPPING, SEEK IMMEDIATE MEDICAL ATTENTION", Color(255, 0, 0, 255))
    end

    ply.ixTraumaCooldown = CurTime() + traumaCooldown
end

local function ResetPlayerTrauma(ply)
    if ply:Team() == FACTION_CCA and ix.config.Get("cityCode", 1) == 1 and playerTrauma[ply] == 0 and ccaDeaths == 0 then
        StopCivilUnrest()
    end
end

timer.Create("ResetPlayerTrauma", 180, 0, function()
    if ix.config.Get("cityCode", 1) == 1 then
        for _, ply in ipairs(player.GetAll()) do
            ResetPlayerTrauma(ply)
        end
    end
end)
