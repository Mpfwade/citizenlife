local PLUGIN = PLUGIN
local DispatchAnontimer = false
local shouldDispatchAnon = false
local weaponlp = false
local arealp = false

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
}

function PLUGIN:GetCameraRelationship(client)
    if client:IsCombine() then return D_LI end
    local weapon = client:GetActiveWeapon()
    local area = client:GetArea()

    if IsValid(weapon) then
        local weaponClass = weapon:GetClass()

        if hatedWeapons[weaponClass] and not client.ixBandanaEquipped then
            giveBOL = true
            shouldDispatchAnon = true
            weaponlp = true

            return D_HT, "@relationArmed"
        end
    end

    if client:Team() == FACTION_CITIZEN and not client.ixBandanaEquipped then
        if area == "Intake-Hub 1" then
            giveBOL = false
            shouldDispatchAnon = false

            return D_HT, "@relationArea"
        elseif area == "404 Zone" then
            giveBOL = true
            shouldDispatchAnon = true
            arealp = true

            return D_HT, "@relationArea404"
        elseif area == "Restricted-Block" then
            giveBOL = true
            shouldDispatchAnon = true
            arealp = true

            return D_HT, "@relationArea404"
        elseif not area or area == "" then
            return D_HT, false
        end
    else
        return
    end

    if client:GetNWBool("ixActiveBOL") then return D_HT, "@relationUPI" end

    return D_NU
end

function PLUGIN:OnFoundPlayer(entity, client)
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

        if giveBOL == true and client:GetNWBool("ixActiveBOL", false) then
            client:SetNWBool("ixActiveBOL", true)
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

    if Schema.AddWaypoint and notice then
        Schema:AddWaypoint(client:GetPos(), notice, color or Color(255, 0, 0), 30, nil, name)
    end

    if Schema.AddWaypoint and notice then
        Schema:AddWaypoint(client:GetPos(), notice, color or Color(255, 0, 0), 30, nil, name)
    end
end

function PLUGIN:OnDestroyed(entity, client)
    local name = entity:GetName() ~= "" and entity:GetName() or "DISP"

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