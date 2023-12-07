function PLUGIN:SetupTimer(client, character)
    local steamID = client:SteamID64()

    timer.Create("ixWarmth" .. steamID, ix.config.Get("warmthTickTime", 5), 0, function()
        if IsValid(client) and character then
            self:WarmthTick(client, character, ix.config.Get("warmthTickTime", 5))
        else
            timer.Remove("ixWarmth" .. steamID)
        end
    end)
end

function PLUGIN:SetupAllTimers()
    for _, v in ipairs(player.GetAll()) do
        local character = v:GetCharacter()

        if character then
            self:SetupTimer(v, character)
        end
    end
end

function PLUGIN:RemoveAllTimers()
    for _, v in ipairs(player.GetAll()) do
        timer.Remove("ixWarmth" .. v:SteamID64())
    end
end

function PLUGIN:WarmthEnabled()
    self:SetupAllTimers()
end

function PLUGIN:WarmthDisabled()
    self:RemoveAllTimers()
end

function PLUGIN:PlayerLoadedCharacter(client, character, lastCharacter)
    if ix.config.Get("warmthEnabled", false) then
        self:SetupTimer(client, character)
    end
end

function PLUGIN:PlayerDeath(client)
    local character = client:GetCharacter()

    if timer.Exists("shiver_"..client:SteamID()) then
        timer.Remove("shiver_"..client:SteamID())
    end

    if character then
        character:SetWarmth(100)
    end
end

function PLUGIN:WarmthTick(client, character, delta)
    if not client:Alive() or client:GetMoveType() == MOVETYPE_NOCLIP or hook.Run("ShouldTickWarmth", client) == false or self:GetTemperature() > ix.config.Get("warmthMinTemp", 5) or client:Team() == FACTION_CCA or client:Team() == FACTION_OTA then
        return
    end

    local scale = 1

    if self:PlayerIsInside(client) then
        scale = -ix.config.Get("warmthRecoverScale", 0.5)
    end

    -- Check to see if the player is near any warmth-generating entities
    local entities = ents.FindInSphere(client:GetPos(), self.warmthEntityDistance)

    for _, v in ipairs(entities) do
        if self.warmthEntities[v:GetClass()] then
            scale = -ix.config.Get("warmthFireScale", 2)
        end
    end

    local equippedItems = {
        ["coat"] = 1.95,
        ["bluebeanie"] = 0.55,
        ["greenbeanie"] = 0.55,
        ["gloves"] = 0.50,
    }

    -- Add more items and their corresponding scale values here
    for itemID, itemScale in pairs(equippedItems) do
        local item = character:GetInventory():GetItemsByUniqueID(itemID)[1]

        if item and item:GetData("equip") == true then
            -- Adjust the scale based on the equipped items
            scale = scale - itemScale
        end
    end

    -- Update character warmth
    local health = client:Health() 
    local warmth = character:GetWarmth()
    local newWarmth = math.Clamp(warmth - scale * (delta / ix.config.Get("warmthLossTime", 5)), 0, 100)
    
    if client:IsCombine() then
        newWarmth = 100
    end

    character:SetWarmth(newWarmth)

    if newWarmth <= 40 and warmth > 0 then
        timer.Create("shiver_"..client:SteamID(), 20, 0, function()
            util.ScreenShake(client:GetPos(), 5, 5, 3, 500)
			ix.chat.Send(client, "me", "starts to shiver aggressively") -- Make the player say the text in chat
        end)
    elseif newWarmth > 40 then
        if timer.Exists("shiver_"..client:SteamID()) then
            timer.Remove("shiver_"..client:SteamID())
        end

    elseif newWarmth > 40 and timer.Exists("shiver_"..client:SteamID()) then
        timer.Remove("shiver_"..client:SteamID())
    
    elseif newWarmth == 0 then
        local damage = ix.config.Get("warmthDamage", 2)

        if damage > 0 and health > 5 then
            -- Damage the player if we've run out of warmth
            client:SetHealth(math.max(5, client:Health() - damage))
        elseif newWarmth == 0 and ix.config.Get("warmthKill", false) then
            -- Kill the player if necessary
            client:Kill()
        end
    end
end
