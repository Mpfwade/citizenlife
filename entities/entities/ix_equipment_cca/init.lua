AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("imgui.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/fruity/new_combine_monitor2_small.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then phys:Wake() end

    -- Create the env_sprite entity
    self:CreateSpriteGlow()
end

function ENT:CreateSpriteGlow()
    if SERVER then
        local sprite = ents.Create("env_sprite")
        if IsValid(sprite) then
            sprite:SetKeyValue("model", "sprites/glow01.spr")  -- Sprite model path
            sprite:SetKeyValue("rendermode", "5")  
            sprite:SetKeyValue("renderfx", "1000") 
            sprite:SetKeyValue("scale", "2.0")  
            sprite:SetKeyValue("renderamt", "50")  
            sprite:SetKeyValue("rendercolor", "0, 94, 201")  
            sprite:SetKeyValue("HDRColorScale", "5.5")  
            sprite:SetParent(self)  
            sprite:SetLocalPos(Vector(20, 0, -0.5))  
            sprite:SetLocalAngles(self:GetAngles())
            sprite:Spawn()
            sprite:Activate()
        end
        
        -- Create the dynamic light
        local light = ents.Create("light_dynamic")
        if IsValid(light) then
            local forward = self:GetForward()  -- Get the entity's forward direction
            light:SetPos(self:GetPos() + forward * 20 + Vector(0, 0, 0))  -- Position the light (moved 30 units forward and 50 units up)
            light:SetKeyValue("distance", "200")  -- Light range
            light:SetKeyValue("brightness", "3")  -- Light brightness
            light:SetKeyValue("enableshadows", "1")
            light:SetKeyValue("style", "0")  -- Constant light
            light:SetKeyValue("rendercolor", "0 60 170")  -- Blue color matching the sprite
            light:SetParent(self)  -- Parent it to the entity
            light:Spawn()
            light:Activate()
            light:Fire("TurnOn", "", 0)  -- Turn on the light
        end
    end
end

if SERVER then
    util.AddNetworkString("SelectRank")
    net.Receive("SelectRank", function(len, client)
        local rankIndex = net.ReadInt(32)
        local ent = client:GetEyeTrace().Entity
        if IsValid(ent) and ent:GetClass() == "ix_equipment_cca" then ent:SelectRank(client, rankIndex) end
    end)

    function ENT:SelectRank(client, rankIndex)
        if not IsValid(client) or not client:GetCharacter() then return end
        local char = client:GetCharacter()
        local rankInfo = ix.ranks.cca[rankIndex]
        if not rankInfo then
            client:Notify("Invalid rank selection.")
            return
        end

        local RANK_SELECT_COOLDOWN = 5
        client.lastRankSelect = client.lastRankSelect or 0
        if CurTime() < client.lastRankSelect + RANK_SELECT_COOLDOWN then
            client:ChatPrint("<::Please wait before selecting another rank.::>")
            return
        end

        client.lastRankSelect = CurTime()
        if rankInfo.xp and tonumber(client:GetRP()) < rankInfo.xp then
            util.AddNetworkString("DisplayError")
            net.Start("DisplayError")
            net.WriteString("REQUIRES MORE RANK POINTS FOR THIS RANK.")
            net.Send(client)
            return
        end

        client:EmitSound("buttons/combine_button1.wav")
        char:SetClass(rankInfo.class)
        client:SetHealth(client:GetMaxHealth() + rankInfo.health)
        client:SetArmor(client:GetMaxArmor() + rankInfo.armor)
        local currentName = char:GetName()
        local randomPart = currentName:match("c17:.-%.(.+)$")
        if randomPart then
            local newName = "c17:" .. rankInfo.name .. "." .. randomPart
            char:SetName(newName)
            client:ChatPrint('The Dispatch states, "<:: WELCOME '.. rankInfo.name .. '. UNIT NAME UPDATED TO: ' .. newName .. '. REMINDER: MEMORY REPLACEMENT IS THE FIRST STEP TOWARDS RANK PRIVILEGES. ::>"')
            client:EmitSound("npc/overwatch/radiovoice/remindermemoryreplacement.wav")
        else
            client:Notify("Error updating name. Please contact an administrator.")
        end

        timer.Simple(3, function()
            if IsValid(client) then -- Add a delay before making the player say something in chat
                client:ConCommand('say "/r 10-8"')
            end
        end)
    end
end