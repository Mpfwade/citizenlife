local PLUGIN = PLUGIN

function PLUGIN:CharacterLoaded(char)
local ply = char:GetPlayer()

     if ply:GetSquad() then
         ply:SetNetVar("squadleader", nil)
         ply:SetNetVar("squad", nil)
     end
end