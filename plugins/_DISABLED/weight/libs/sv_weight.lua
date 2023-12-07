ix.weight = ix.weight or {}

function ix.weight.CalculateWeight(character)
    local inventory = character:GetInventory()
    local weight = 0

    for i, v in pairs(inventory:GetItems()) do
        if v:GetWeight() then
            weight = weight + v:GetWeight()
        end
    end

    return weight
end

function ix.char.Create(data, callback)
    local timeStamp = math.floor(os.time())
    data.money = data.money or ix.config.Get("defaultMoney", 0)
    data.schema = Schema and Schema.folder or "helix"
    data.createTime = timeStamp
    data.lastJoinTime = timeStamp
    local query = mysql:Insert("ix_characters")
    query:Insert("name", data.name or "")
    query:Insert("description", data.description or "")
    query:Insert("model", data.model or "models/error.mdl")
    query:Insert("schema", Schema and Schema.folder or "helix")
    query:Insert("create_time", data.createTime)
    query:Insert("last_join_time", data.lastJoinTime)
    query:Insert("steamid", data.steamID)
    query:Insert("faction", data.faction or "Unknown")
    query:Insert("money", data.money)
    query:Insert("data", util.TableToJSON(data.data or {}))

    query:Callback(function(result, status, lastID)
        local invQuery = mysql:Insert("ix_inventories")
        invQuery:Insert("character_id", lastID)

        invQuery:Callback(function(invResult, invStats, invLastID)
            local client = player.GetBySteamID64(data.steamID)
            ix.char.RestoreVars(data, data)
            local w, h = 15, 15
            local character = ix.char.New(data, lastID, client, data.steamID)
            local inventory = ix.inventory.Create(w, h, invLastID)

            character.vars.inv = {inventory}

            inventory:SetOwner(lastID)
            ix.char.loaded[lastID] = character
            table.insert(ix.char.cache[data.steamID], lastID)

            if callback then
                callback(lastID)
            end
        end)

        invQuery:Execute()
    end)

    query:Execute()
end

function ix.char.Restore(client, callback, bNoCache, id)
    local steamID64 = client:SteamID64()
    local cache = ix.char.cache[steamID64]

    if cache and not bNoCache then
        for _, v in ipairs(cache) do
            local character = ix.char.loaded[v]

            if character and not IsValid(character.client) then
                character.player = client
            end
        end

        if callback then
            callback(cache)
        end

        return
    end

    local query = mysql:Select("ix_characters")
    query:Select("id")
    ix.char.RestoreVars(query)
    query:Where("schema", Schema.folder)
    query:Where("steamid", steamID64)

    if id then
        query:Where("id", id)
    end

    query:Callback(function(result)
        local characters = {}

        for _, v in ipairs(result or {}) do
            local charID = tonumber(v.id)

            if charID then
                local data = {
                    steamID = steamID64
                }

                ix.char.RestoreVars(data, v)
                characters[#characters + 1] = charID
                local character = ix.char.New(data, charID, client)
                hook.Run("CharacterRestored", character)

                character.vars.inv = {
                    [1] = -1,
                }

                local invQuery = mysql:Select("ix_inventories")
                invQuery:Select("inventory_id")
                invQuery:Select("inventory_type")
                invQuery:Where("character_id", charID)

                invQuery:Callback(function(info)
                    if istable(info) and #info > 0 then
                        local inventories = {}

                        for _, v2 in pairs(info) do
                            if v2.inventory_type and isstring(v2.inventory_type) and v2.inventory_type == "NULL" then
                                v2.inventory_type = nil
                            end

                            if hook.Run("ShouldRestoreInventory", charID, v2.inventory_id, v2.inventory_type) ~= false then
                                local w, h = 15, 15
                                local invType

                                if v2.inventory_type then
                                    invType = ix.item.inventoryTypes[v2.inventory_type]

                                    if invType then
                                        w, h = invType.w, invType.h
                                    end
                                end

                                inventories[tonumber(v2.inventory_id)] = {w, h, v2.inventory_type}
                            end
                        end

                        ix.inventory.Restore(inventories, nil, nil, function(inventory)
                            local inventoryType = inventories[inventory:GetID()][3]

                            if inventoryType then
                                inventory.vars.isBag = inventoryType
                                table.insert(character.vars.inv, inventory)
                            else
                                character.vars.inv[1] = inventory
                            end

                            inventory:SetOwner(charID)
                        end, true)
                    else
                        local insertQuery = mysql:Insert("ix_inventories")
                        insertQuery:Insert("character_id", charID)

                        insertQuery:Callback(function(_, status, lastID)
                            local w, h = 15, 15
                            local inventory = ix.inventory.Create(w, h, lastID)
                            inventory:SetOwner(charID)

                            character.vars.inv = {inventory}
                        end)

                        insertQuery:Execute()
                    end
                end)

                invQuery:Execute()
                ix.char.loaded[charID] = character
            else
                ErrorNoHalt("[Helix] Attempt to load character with invalid ID '" .. tostring(id) .. "'!")
            end
        end

        if callback then
            callback(characters)
        end

        ix.char.cache[steamID64] = characters
    end)

    query:Execute()
end