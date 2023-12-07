-- This code assumes you have already set up a Helix schema and created a plugin folder for this script.
PLUGIN.name = "Door Open Check and Anim"
PLUGIN.author = "Ryder"
PLUGIN.description = "Checks if a player is attempting to open a door."

function PLUGIN:CanPlayerUseDoor(client, door)
    -- Check if the player is trying to open a door
    if door:IsDoor() and door:GetNetVar("locked") then return false, "This door is locked." end -- The door is locked, prevent the player from opening it
    -- Allow the player to open the door by default

    return true
end

if SERVER then
    -- Register the hook on the server-side
    hook.Add("PlayerUse", "DoorOpenCheck", function(client, entity)
        -- Check if the entity being used is a door
        if IsValid(entity) and entity:IsDoor() then
            local allowed, reason = hook.Run("CanPlayerUseDoor", player, entity)


            -- If the CanPlayerUseDoor hook returns false, prevent the player from opening the door
            if allowed == false then
                client:ChatPrint(reason)

                return false
            elseif allowed == true then
            client:ForceSequence("Open_door_towards_right", nil, 0.5, true)
            end
        end
    end)
end