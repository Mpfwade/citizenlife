local PLUGIN = PLUGIN
PLUGIN.name = "Permakill"
PLUGIN.author = "Thadah Denyse"
PLUGIN.description = "Adds permanent death in the server options."

ix.config.Add("permakill", false, "Whether or not permakill is activated on the server.", nil, {
    category = "Permakill"
})

ix.config.Add("permakillWorld", false, "Whether or not world and self damage produce permanent death.", nil, {
    category = "Permakill"
})

local decreaseInterval = 1800

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

        if not client:IsCombine() then
            character:SetData("permakilled", true)
        end
    end
end

function PLUGIN:DoPlayerDeath(ply, attacker, dmginfo)
    ply:ChatPrint("You do not remember what killed you or what led to your death...")

    if (dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BLAST) or dmginfo:IsDamageType(DMG_CLUB) or dmginfo:IsDamageType(DMG_BUCKSHOT)) and not ply:IsCombine() then
        local character = ply:GetCharacter()

        if character then
            character:SetData("deathTimes", character:GetData("deathTimes", 0) + 1)
            print("[DEATHPERMA " .. character:GetData("deathTimes") .. " ]")
            character:SetData("lastDeathTime", CurTime())
        end
    end
end


timer.Create("DeathTimeDecrease", decreaseInterval, 0, function()
    for _, ply in ipairs(player.GetAll()) do
        if not ply:IsCombine() then
            local character = ply:GetCharacter()

            if character and IsValid(ply) and character:GetData("lastDeathTime") then
                if character:GetData("deathTimes", 0) > 0 and CurTime() - character:GetData("lastDeathTime") >= decreaseInterval then
                    character:SetData("deathTimes", math.max(character:GetData("deathTimes", 0) - 1, 0))
                end
            end
        end
    end
end)

function PLUGIN:PlayerSpawn(client)
    local character = client:GetCharacter()

    if ix.config.Get("permakill") and character and character:GetData("permakilled") and not client:IsCombine() then
        local deathTimes = character:GetData("deathTimes", 0)

        if deathTimes > 3 then
            character:Ban()
            character:SetData("permakilled", false) -- Reset the permakilled data field
        end
    end
end

function PLUGIN:PlayerLoadout(ply)
    local character = ply:GetCharacter()

    if character and not ply:IsCombine() then
        local deathTimes = character:GetData("deathTimes", 0)
        if deathTimes == 1 then
            -- Add debuffs for the first death
            character:SetHunger(65) -- Reduced hunger value (60 instead of 100)
            ply:SetHealth(85)
        elseif deathTimes == 2 then
            -- Add debuffs for the second death
            character:SetHunger(45) -- Further reduced hunger value (45 instead of 100)
            ply:SetHealth(60) -- Reduced health value (75 instead of 100)
        elseif deathTimes == 3 then
            -- Add debuffs for the third death
            character:SetHunger(25) -- Further reduced hunger value (25 instead of 100)
            ply:SetHealth(35) -- Reduced health value (35 instead of 100)
        end
    end
end
