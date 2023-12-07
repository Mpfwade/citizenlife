local PLUGIN = PLUGIN

function PLUGIN:PlayerInteractItem(client, action, item)
    local dropAnim = "ThrowItem"

    local hands = {
        ["ix_keys"] = true,
        ["ix_hands"] = true
    }

    if action == "drop" and hands[client:GetActiveWeapon():GetClass()] then
        client:ForceSequence(dropAnim, nil, 1, true)
    end

    local itemEntity = item.entity

    if itemEntity then
        local trace = util.TraceLine({
            start = client:EyePos(),
            endpos = client:EyePos() + client:EyeAngles():Forward() * 100,
            filter = {client, itemEntity}
        })

        local pickupAnim = "Pickup"

        if action == "take" then
            if trace.HitWorld and not client:IsWepRaised() then
                client:ForceSequence(pickupAnim, nil, 1, true)
                ix.chat.Send(client, "me", "bends over to pick up an item.")
            elseif not trace.HitWorld then
                ix.chat.Send(client, "me", "reaches out their arm to pick up an item.")
            end
        end
    end
end

function PLUGIN:Equip(client, bNoSelect, bNoSound)
    if not client:IsCombine() then
        local strapAnim = "gunrack"

        if itemTable:GetData("equip") then
            client:ForceSequence(strapAnim, nil, 1, true)
        end
    end
end

local doorLockedNotified = {} -- Table to track door locked notifications
local doorOpen = false

-- Register the hook on the server-side
hook.Add("PlayerUse", "DoorOpenCheck", function(client, entity)
        local hands = {
            ["ix_keys"] = true,
            ["ix_hands"] = true
        }

        -- Check if the entity being used is a door
        if IsValid(entity) and entity:IsDoor() then
            if entity:IsLocked() then
                -- Check if the door locked notification has already been sent to the player
                if not doorLockedNotified[entity] then
                    client:ChatPrint("This door is locked")
                    doorLockedNotified[entity] = true -- Set the notification flag for this door
                    -- Start a timer to reset the flag after 5 seconds
                    timer.Simple(
                        5,
                        function()
                            doorLockedNotified[entity] = false -- Reset the notification flag for this door
                        end
                    )
                end
            else
                if not client:IsWepRaised() or not client:IsRestricted() and client:IsPlayer() and hands[client:GetActiveWeapon():GetClass()] and client:Alive() then
                        doorOpen = true
                        client:ForceSequence("Open_door_towards_right", nil, 0.5, true)
                        timer.Simple(
                            0.4,
                            function()
                                client:LeaveSequence()
                                doorOpen = false
                            end
                        )
                    end
                end
            end
        end
)

function Schema:CanPlayerThrowPunch(ply)
    if ply:IsWepRaised() then
        if SERVER then
            ply:ForceSequence("MeleeAttack01", nil, 0.5, true)
        end
    end

    if not doorOpen and ply:IsWepRaised() then
        return true
    else
        return false
    end
end
