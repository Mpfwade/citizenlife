local PLUGIN = PLUGIN

PLUGIN.name = "Doorspeed"
PLUGIN.author = "Citizenlifedev"
PLUGIN.description = "Modifies door speed to open slowly when crouching or holding the alt key, and faster when sprinting"

local DOOR_ANTISPAM_DELAY = 3 

-- Function to check if an entity is a door that supports modified opening behaviors.
local function IsDoor(entity)
    return entity:GetClass() == "prop_door_rotating" or entity:GetClass() == "func_door_rotating"
end

-- Function to reset the door's speed to its original value.
local function ResetDoorSpeed(entity)
    if entity.oldspeed and IsValid(entity) then
        entity:SetSaveValue("speed", entity.oldspeed)
        entity.stealthopen = false
        entity.fastopen = false
        entity.oldspeed = nil
    end
end

-- slow
local function StealthOpenDoor(entity)
    ResetDoorSpeed(entity)
    entity.stealthopen = true
    entity.oldspeed = entity:GetInternalVariable("speed")
    entity:SetSaveValue("speed", entity.oldspeed / 2) -- Half the speed for stealth opening.

    local uniqueIdent = entity:EntIndex() and entity:EntIndex() or tostring(entity:GetPos())
    timer.Create("resetdoorstealthval" .. uniqueIdent, 4, 1, function()
        ResetDoorSpeed(entity)
    end)
end

-- fast
local function FastOpenDoor(entity, player)
    
    local function ApplyFastOpen(target)
        if target.lastFastOpen and (CurTime() - target.lastFastOpen < DOOR_ANTISPAM_DELAY) then
            return 
        end
        ResetDoorSpeed(target)
        target.fastopen = true
        target.oldspeed = target:GetInternalVariable("speed")
        target:SetSaveValue("speed", target.oldspeed * 3) -- speed mult
        target:EmitSound("physics/wood/wood_plank_break1.wav")
        if IsValid(player) then
            target:Fire("OpenAwayFrom", tostring(player), 0)
        end
        target.lastFastOpen = CurTime()
        local uniqueIdent = target:EntIndex() and target:EntIndex() or tostring(target:GetPos())
        timer.Create("resetdoorfastval" .. uniqueIdent, 4, 1, function()
            ResetDoorSpeed(target)
        end)
    end
    
    
    ApplyFastOpen(entity)
    
    
    local master = entity:GetInternalVariable("m_hMaster")
    if IsValid(master) and IsDoor(master) then
        ApplyFastOpen(master)
    end
end


function PLUGIN:PlayerUse(player, entity)
    if IsDoor(entity) then
        local velocity = player:GetVelocity():Length()
        local runningSpeed = 165 

        if velocity > runningSpeed then
            FastOpenDoor(entity, player)
        elseif player:Crouching() or player:KeyDown(IN_WALK) then
            StealthOpenDoor(entity)
        else
            ResetDoorSpeed(entity)
        end
    end
end


function PLUGIN:EntityEmitSound(data)
    if IsValid(data.Entity) and IsDoor(data.Entity) and (data.Entity.stealthopen or data.Entity.fastopen) then
        data.Volume = data.Entity.stealthopen and data.Volume * 0.25 or data.Volume
        return true
    end
end