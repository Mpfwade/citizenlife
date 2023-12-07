
local CHAR = ix.meta.character
local META = FindMetaTable("Player")

function CHAR:InChatterArea()
    local player = self:GetPlayer()
    local currentArea = player:GetArea() or nil
    if (currentArea) then
        local stored = ix.area.stored[player:GetArea()] or nil
        if (stored and player:GetMoveType() ~= MOVETYPE_NOCLIP) then
            local clientPos = player:GetPos() + player:OBBCenter()
            return stored.type == 'chatter' and clientPos:WithinAABox(stored.startPosition, stored.endPosition), stored
        end
    else
        return false
    end
end

function META:InChatterArea()
    local character = self:GetCharacter()
    if (character) then
        return character:InChatterArea()
    else
        return false
    end
end

