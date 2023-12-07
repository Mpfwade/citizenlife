local PLUGIN = PLUGIN

function PLUGIN:PlayerInteractItem(client, action, item)
    local itemEntity = item.entity

    if itemEntity then
        local trace = util.TraceLine({
            start = client:EyePos(),
            endpos = client:EyePos() + client:EyeAngles():Forward() * 100,
            filter = {client, itemEntity}
        })

        local pickupAnim = "Pickup"
        local bool = true

        if action == "take" then
            if trace.HitWorld then
                client:ForceSequence(pickupAnim, nil, 1, bNoFreeze)
                ix.chat.Send(client, "me", "bends over to pick up an item.")
            elseif not trace.HitWorld then
                ix.chat.Send(client, "me", "reaches out their arm to pick up an item.")
            end
        end
    end
end

function PLUGIN:Equip(client, bNoSelect, bNoSound)
    local strapAnim = "gunrack"

    if itemTable:GetData("equip") then
        client:ForceSequence(strapAnim, nil, 1, true)
    end
end