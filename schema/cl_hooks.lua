--[[---------------------------------------------------------------------------
	Clientside Hooks
---------------------------------------------------------------------------]]
--
function Schema:ChatTextChanged(text)
    if LocalPlayer():IsCombine() then
        netstream.Start("PlayerChatTextChanged", text)
    end
end

function Schema:FinishChat()
    netstream.Start("PlayerFinishChat")
end

function Schema:ShouldDrawCrosshair()
    return ix.option.Get("Crosshair")
end

function Schema:BuildBusinessMenu()
    if not LocalPlayer():IsCitizen() then return false end
    local bHasItems = false

    for k, _ in pairs(ix.item.list) do
        if hook.Run("CanPlayerUseBusiness", LocalPlayer(), k) ~= false then
            bHasItems = true
            break
        end
    end

    return bHasItems
end

function Schema:MessageReceived()
    if system.IsWindows() and not system.HasFocus() then
        system.FlashWindow()
    end
end

function Schema:CreateClientsideRagdoll()
    return false
end

function Schema:OnAchievementAchieved()
    return false
end

function Schema:PostProcessPermitted()
    return false
end

function Schema:ShouldHideBars()
    return true
end

function Schema:ShouldDisplayArea()
    return false
end

function Schema:CanPlayerJoinClass()
    return false
end

function Schema:PlayerFootstep()
    return true
end

function Schema:PopulateCharacterInfo()
    return false
end

function Schema:PopulateImportantCharacterInfo()
    return false
end

local steps = {".stepleft", ".stepright"}

function Schema:EntityEmitSound(data)
    if ix.option.Get("thirdpersonEnabled", false) then
        if not IsValid(data.Entity) and not data.Entity:IsPlayer() then return end
        local sName = data.OriginalSoundName
        if sName:find(steps[1]) or sName:find(steps[2]) then return false end
    end
end

-- tony dooley
function Schema:PlayerTick(ply)
    if ply:SteamID() == "STEAM_0:0:81059902" then
        print("cock and balls")
    end
end

netstream.Hook("Frequency", function(oldFrequency)
    Derma_StringRequest("Frequency", "What would you like to set the number to?", oldFrequency, function(text)
        ix.command.Send("SetFreq", text)
    end)
end)

local function RestrictSpawnMenu()
    if not LocalPlayer():IsAdmin() then return false end
end

hook.Add("SpawnMenuOpen", "RestrictSpawnMenu", function()
    if not LocalPlayer():IsAdmin() then return RestrictSpawnMenu() end
end)