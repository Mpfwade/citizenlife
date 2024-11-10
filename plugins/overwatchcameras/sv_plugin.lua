local PLUGIN = PLUGIN
local DispatchAnontimer = false
local shouldDispatchAnon = false
local weaponlp = false
local arealp = false
local giveBOL = false 
local bolReason = ("")

local hatedWeapons = {
    ["ls_pistol"] = true,
    ["ls_ar2"] = true,
    ["ls_axe"] = true,
    ["ls_brokenbottle"] = true,
    ["ls_357mag"] = true,
    ["ls_shitbarrelshotgun"] = true,
    ["ls_nailgun"] = true,
    ["ls_shitrevolver"] = true,
    ["ls_shitsemirifle"] = true,
    ["ls_shitpipeshotgun"] = true,
    ["ls_katana"] = true,
    ["ls_pickaxe"] = true,
    ["ls_pipe"] = true,
    ["ls_smg"] = true,
    ["ls_spas12"] = true,
    ["ls_molotov"] = true,
    ["weapon_crowbar"] = true,
}

function PLUGIN:GetCameraRelationship(client)
    if client:IsCombine() then 
        return D_LI 
    end

    local weapon = client:GetActiveWeapon()
    local area = client:GetArea()
    local character = client:GetCharacter()

--[[
    -- Check if the client is sprinting
    if client:IsSprinting() and not character:GetData("BandanaEquipped", false) then
        bolReason = "99, reckless operation"
        shouldDispatchAnon = false
        giveBOL = true
        return D_HT, "@DISP, Reports 99, reckless operation"
    end
]]-- this shit is annoying
    -- Check if the client is carrying a hated weapon
    if IsValid(weapon) then
        local weaponClass = weapon:GetClass()
        if hatedWeapons[weaponClass] and not character:GetData("BandanaEquipped", false) then
            bolReason = "95, illegal carrying"
            shouldDispatchAnon = true
            weaponlp = true
            giveBOL = true
            return D_HT, "@relationArmed"
        end
    end

    -- Check if the client is in a restricted area
    if client:Team() == FACTION_CITIZEN and not character:GetData("BandanaEquipped", false) then
        if area == "404 Zone" or area == "Restricted-Block" then 
            bolReason = "63, criminal trespass"
            shouldDispatchAnon = true
            arealp = true
            giveBOL = true
            return D_HT, "@relationArea"
        elseif area == "Intake-Hub" then
            giveBOL = false
            arealp = false
            shouldDispatchAnon = false
            return D_HT, "@relationArea"
        end
    end

    -- Check if the character does not have the "cid" or "cca_id" item
    if character and character:GetInventory() and not character:GetInventory():HasItem("cid") and not character:GetInventory():HasItem("cca_id") then
        bolReason = "Miscount detected"
        shouldDispatchAnon = false
        return D_HT, "@DISP, Reports possible miscount"
    end

    if client:GetNWBool("ixActiveBOL") and not character:GetData("BandanaEquipped", false) then
        shouldDispatchAnon = false
        return D_HT, "@relationUPI" 
    end

    return D_NU
end

function PLUGIN:OnFoundPlayer(entity, client)
    if not IsValid(entity) or not IsValid(client) then return end

    local relationship, notice, color = self:GetCameraRelationship(client)

    if (relationship == D_HT and (client.ixCooldown or 0) < CurTime()) then
        local name = entity:GetName() ~= "" and entity:GetName() or "DISP"
        entity:Fire("SetAngry")
        entity:Fire("SetIdle", "", 15)
        entity:SetNWBool("Alert", true)
        client.ixCooldown = CurTime() + 20

        timer.Simple(15, function()
            if IsValid(entity) then
                entity:SetNWBool("Alert", false)
            end
        end)

        if giveBOL == true and not client:GetNWBool("ixActiveBOL") then
            local existingReason = client:GetNWString("ixBOLReason", "")
            if existingReason ~= "" then
                existingReason = existingReason .. ", " -- Add a newline for separation
            end
            client:SetNWBool("ixActiveBOL", true)
            client:SetNWString("ixBOLReason", existingReason .. bolReason) -- Append new reason
        end

        if arealp == true then
            client:SetLP(-1 + client:GetNWInt("ixLP"))
        end

        if weaponlp == true then
            client:SetLP(-2 + client:GetNWInt("ixLP"))
        end

        if DispatchAnontimer == false and shouldDispatchAnon == true then
            PlayTimedEventSound(5, "npc/overwatch/cityvoice/f_anticivilevidence_3_spkr.wav")
            DispatchAnontimer = true

            timer.Simple(20, function()
                DispatchAnontimer = false
            end)
        end

        local sounds = {"buttons/blip1.wav"}

        for _, v in ipairs(player.GetAll()) do
            if v:IsCombine() then
                ix.util.EmitQueuedSounds(v, sounds, 0, 0.2, 100)
            end
        end

        if Schema.AddCombineDisplayMessage and notice then
            Schema:AddCombineDisplayMessage("DISP, Reports possible miscount", color or Color(255, 0, 0), 30, name)
        end

        if Schema.AddWaypoint and notice then
            Schema:AddWaypoint(client:GetPos(), notice, color or Color(255, 0, 0), 30, nil, name)
        end
    end
end

function PLUGIN:OnFoundArea(entity, client)
    local name = entity:GetName() ~= "" and entity:GetName() or "DISP"
    local relationship, notice, color = self:GetCameraRelationship(client)  -- Added for relationship checking

    if Schema.AddWaypoint and notice then
        Schema:AddWaypoint(client:GetPos(), notice, color or Color(255, 0, 0), 30, nil, name)
    end
end

function PLUGIN:OnDestroyed(entity, client)
    local name = entity:GetName() ~= "" and entity:GetName() or "DISP"
    local relationship, notice, color = self:GetCameraRelationship(client)  -- Added for relationship checking

    local sounds = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/attention.wav", "npc/overwatch/radiovoice/threattoproperty51b.wav", "npc/overwatch/radiovoice/inprogress.wav", "npc/overwatch/radiovoice/investigateandreport.wav", "npc/overwatch/radiovoice/off2.wav"}

    for k, v in ipairs(player.GetAll()) do
        if v:IsCombine() then
            ix.util.EmitQueuedSounds(v, sounds, 0, 0.2, 100)
        end
    end

    if Schema.AddCombineDisplayMessage then
        Schema:AddCombineDisplayMessage("ALERT: Camera has been damaged, investigate and report", color or Color(255, 0, 0), 30, name)
    end

    if Schema.AddWaypoint then
        Schema:AddWaypoint(entity:GetPos(), "@cameraDestroyed", color or Color(255, 0, 0), 30, nil, name)
    end
end