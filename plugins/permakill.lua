local PLUGIN = PLUGIN
PLUGIN.name = "Permakill"
PLUGIN.author = "Thadah Denyse"
PLUGIN.description = "Adds permanent death in the server options."
ix.config.Add(
    "permakill",
    false,
    "Whether or not permakill is activated on the server.",
    nil,
    {
        category = "Permakill"
    }
)

ix.config.Add(
    "permakillWorld",
    false,
    "Whether or not world and self damage produce permanent death.",
    nil,
    {
        category = "Permakill"
    }
)

local decreaseInterval = 3600
function PLUGIN:PlayerLoadedCharacter(client, char, currentChar)
    if not client:IsCombine() then
        char:SetData("deathTimes", 0)
        char:SetData("lastDeathTime", 0)
    end
end

function PLUGIN:PlayerDeath(client, inflictor, attacker)
    local character = client:GetCharacter()
    if ix.config.Get("permakill") and character then
        if hook.Run("ShouldPermakillCharacter", client, character, inflictor, attacker) == false and character:GetData("deathTimes") > 3 then return end
        if ix.config.Get("permakillWorld") and (client == attacker or inflictor:IsWorld()) then return end
        if not client:IsCombine() then character:SetData("permakilled", true) end
    end
end

function PLUGIN:DoPlayerDeath(ply, attacker, dmginfo)
    local character = ply:GetCharacter()

    -- Check if the player and character are valid
    if not IsValid(ply) or not character then return end

    ply:ChatPrint("You do not remember what killed you or what led to your death...")
    ply:RemoveDrunkEffect()

    -- Check for specific damage types and whether the player is not a Combine
    if (dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BLAST) or 
        dmginfo:IsDamageType(DMG_CLUB) or dmginfo:IsDamageType(DMG_BUCKSHOT)) and not ply:IsCombine() then
        
        -- Increment death count
        local deathTimes = character:GetData("deathTimes", 0) + 1
        character:SetData("deathTimes", deathTimes)
        print("[DEATHPERMA " .. deathTimes .. " ]")
        character:SetData("lastDeathTime", CurTime())

        -- Apply debuffs based on the number of deaths
        if deathTimes == 1 then
            character:SetHunger(65) -- Reduced hunger value (65 instead of 100)
        elseif deathTimes == 2 then
            character:SetHunger(45) -- Further reduced hunger value (45 instead of 100)
        elseif deathTimes == 3 then
            character:SetHunger(25) -- Further reduced hunger value (25 instead of 100)
        end
    else
        -- Set hunger to full if death is not caused by specified damage types
        character:SetHunger(100)
    end
end

timer.Create(
    "DeathTimeDecrease",
    decreaseInterval,
    0,
    function()
        for _, ply in ipairs(player.GetAll()) do
            if not ply:IsCombine() then
                local character = ply:GetCharacter()
                if character and IsValid(ply) and character:GetData("lastDeathTime") then if character:GetData("deathTimes", 0) > 0 and CurTime() - character:GetData("lastDeathTime") >= decreaseInterval then character:SetData("deathTimes", math.max(character:GetData("deathTimes", 0) - 1, 0)) end end
            end
        end
    end
)

function PLUGIN:PlayerSpawn(client)
    local character = client:GetCharacter()
    if ix.config.Get("permakill") and character and character:GetData("permakilled") and not client:IsCombine() then
        local deathTimes = character:GetData("deathTimes", 0)
        if deathTimes > 2 or character:GetData("ixJailPermaKill") then
            character:Ban()
            character:SetData("permakilled", false) -- Reset the permakilled data field
            character:SetData("ixJailPermaKill", false)
        end
    end
end