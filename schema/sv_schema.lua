--[[---------------------------------------------------------------------------
	Serverside Functions
---------------------------------------------------------------------------]]
--
ix.whitelists = ix.whitelists or {}
ix.whitelists.CCA = ix.whitelists.CCA or {}
ix.whitelists.OTA = ix.whitelists.OTA or {}

ix.whitelists.CCA.Ranks = {
    ["CCA:010"] = {"STEAM_0:1:439353039", "STEAM_0:1:419533834", "STEAM_0:0:503591671", "STEAM_0:1:580954490", "STEAM_0:1:586646981", "STEAM_0:1:465730962", "STEAM_0:0:222027191", "STEAM_0:1:55111005", "STEAM_0:0:567933763", "STEAM_0:0:106851789", "STEAM_0:1:126301365", "STEAM_0:1:174458980", "STEAM_0:0:222071775"},
    -- Silas -- Zare -- Zack -- patar3475 -- armykuba1 -- Syzygy -- Processed Grain -- Foxy -- Rysche -- darqfam4 -- CWJ -- seawolf -- Evan
    ["CCA:015"] = {"STEAM_0:1:439353039", "STEAM_0:1:419533834", "STEAM_0:1:126301365", "STEAM_0:1:586646981", "STEAM_0:0:567933763", "STEAM_0:0:106851789",},
    -- Silas -- Zare -- CWJ -- armykuba1 -- Rysche -- darqfam4
    ["CCA:020"] = {"STEAM_0:1:439353039", "STEAM_0:1:419533834", "STEAM_0:1:126301365", "STEAM_0:1:586646981", "STEAM_0:0:567933763",},
    -- Silas -- Zare -- CWJ -- armykuba1 -- Rysche
    ["CCA:025"] = {"STEAM_0:1:439353039", "STEAM_0:1:419533834", "STEAM_0:1:126301365", "STEAM_0:1:586646981", "STEAM_0:0:567933763",},
    -- Silas -- Zare -- CWJ -- armykuba1 -- Rysche
    ["CCA:030"] = {"STEAM_0:1:439353039", "STEAM_0:1:419533834", "STEAM_0:1:126301365", "STEAM_0:1:586646981", "STEAM_0:0:567933763",},
    -- Silas -- Zare -- CWJ -- armykuba1 -- Rysche
    ["CCA:035"] = {"STEAM_0:1:439353039", "STEAM_0:1:419533834", "STEAM_0:1:126301365", "STEAM_0:1:586646981", "STEAM_0:0:567933763",},
    -- Silas -- Zare -- CWJ -- armykuba1 -- Rysche
    ["CCA:040"] = {"STEAM_0:1:439353039", "STEAM_0:1:419533834", "STEAM_0:1:126301365", "STEAM_0:0:567933763",},
    -- Silas -- Zare -- CWJ -- Rysche
    ["CCA:045"] = {"STEAM_0:1:439353039", "STEAM_0:1:419533834", "STEAM_0:1:126301365", "STEAM_0:0:567933763",},
    -- Silas -- Zare -- CWJ -- Rysche
    ["CCA:050"] = {"STEAM_0:1:439353039", "STEAM_0:1:419533834", "STEAM_0:1:126301365", "STEAM_0:0:567933763",},
    -- Silas -- Zare -- CWJ -- Rysche
    ["CCA:RL"] = {"STEAM_0:1:126301365", "STEAM_0:0:567933763", "STEAM_0:1:465730962",},
    -- CWJ -- Rysche -- Syzygy
    ["CCA:DC"] = {"STEAM_0:1:465730962"}, -- Syzygy
    
}

ix.whitelists.OTA.NoRanks = {
    ["WALLHAMMER"] = {"STEAM_0:0:203818007", "STEAM_0:0:448077906", "STEAM_0:0:89116555", "STEAM_0:0:138626507", "STEAM_0:0:10223064", "STEAM_0:0:199691641", "STEAM_0:0:54754855", "STEAM_0:1:112093491", "STEAM_0:0:455356942", "STEAM_0:1:104896936", "STEAM_0:1:76725981", "STEAM_0:1:599186470", "STEAM_0:0:64132801", "STEAM_0:1:104370902", "STEAM_1:0:203749017", "STEAM_0:0:20320092", "STEAM_0:1:98276136", "STEAM_0:0:503591671", "STEAM_0:1:419533834", "STEAM_0:1:465730962"},
    -- kingdarkness -- prototwat -- sprite cran -- john smith -- xavier -- Revectane -- Diablo -- engi -- tsukii -- phil leotardo -- m3 r88 -- punished glunch -- ovxy -- archer -- detective pat -- adamski -- Syzygy
    ["OWC"] = {"STEAM_0:0:503591671"},
    ["APF"] = {"STEAM_0:0:503591671", "STEAM_0:1:419533834", "STEAM_0:1:98276136",},
}

ix.whitelists.OTA.Ranks = {
    ["ECHO"] = {"STEAM_0:0:222027191", "STEAM_0:1:465730962", "STEAM_0:1:55111005",},
    -- Processed Grain -- Syzygy -- Foxy
    ["OWS"] = {"STEAM_0:0:222027191", "STEAM_0:1:465730962", "STEAM_0:1:55111005",},
    -- Processed Grain -- Syzygy -- Foxy
    ["EOW"] = {"STEAM_0:1:465730962", "STEAM_0:0:222027191", "STEAM_0:1:55111005",}, -- Syzygy
    -- Processed Grain -- Foxy
    ["ORDINAL"] = {"STEAM_0:1:104896936", "STEAM_0:0:229400758", "STEAM_0:0:155006109", "STEAM_0:0:89116555", "STEAM_0:0:20320092", "STEAM_0:0:580428602", "STEAM_0:1:91589611", "STEAM_0:0:554357457", "STEAM_0:0:226903802", "STEAM_0:1:213488223", "STEAM_0:1:75454172", "STEAM_0:0:455356942",},
    -- Phil Leotardo -- tea -- ProvingMedusa -- sprite cran -- adamski -- morph -- breadgaming -- nocturne -- fawful -- lastcrusader -- vault -- tsukii
    ["RANGER"] = {"STEAM_0:0:503591671", "STEAM_0:1:419533834",},
    ["OWC"] = {"STEAM_0:0:503591671"},
}

function Schema:SearchPlayer(ply, target)
    if not target:GetCharacter() or not target:GetCharacter():GetInventory() then return false end
    local name = hook.Run("GetDisplayedName", target) or target:Name()
    local inventory = target:GetCharacter():GetInventory()

    ix.storage.Open(ply, inventory, {
        entity = target,
        name = name
    })

    return true
end

local rebelNPCs = {
    ["npc_citizen"] = true,
    ["npc_vortigaunt"] = true,
}

local combineNPCs = {
    ["npc_cscanner"] = true,
    ["npc_stalker"] = true,
    ["npc_clawscanner"] = true,
    ["npc_turret_floor"] = true,
    ["npc_combine_camera"] = true,
    ["npc_metropolice"] = true,
    ["npc_combine_s"] = true,
    ["npc_manhack"] = true,
    ["npc_rollermine"] = true,
    ["npc_strider"] = true,
    ["npc_hunter"] = true,
    ["npc_stalker"] = true,
}

function Schema:UpdateRelationShip(ent)
    for k, v in pairs(player.GetAll()) do
        if v:IsCombine() or v:IsCA() then
            if combineNPCs[ent:GetClass()] then
                ent:AddEntityRelationship(v, D_LI, 99)
            elseif rebelNPCs[ent:GetClass()] then
                ent:AddEntityRelationship(v, D_HT, 99)
            end
        else
            if combineNPCs[ent:GetClass()] then
                ent:AddEntityRelationship(v, D_HT, 99)
            elseif rebelNPCs[ent:GetClass()] then
                ent:AddEntityRelationship(v, D_LI, 99)
            end
        end
    end
end

function Schema:GiveWeapons(ply, weapons)
    for i, weapon in ipairs(weapons) do
        ply:Give(weapon)
    end
end

function Schema:PlayerModelChanged(client, model)
    local character = client:GetCharacter()

    local descriptions = {
        ["models/police.mdl"] = "A Civil Protection Officer, they're indistinguishable from their peers.",
    }

    local model = character:GetModel()

    if descriptions[model] then
        character:SetDescription(descriptions[model])
    end
end

util.AddNetworkString("ixAddCombineDisplayMessage")

function Schema:AddCombineDisplayMessage(text, color, sound)
    for k, v in pairs(player.GetAll()) do
        if v:IsCombine() then
            net.Start("ixAddCombineDisplayMessage")
            net.WriteString(tostring(text) or "Invalid Input..")
            net.WriteColor(color or color_white)
            net.WriteBool(tobool(sound) or false)
            net.Send(v)
        end
    end
end

function Schema:LoadCombineLocks()
    for _, v in ipairs(ix.data.Get("combineLocks") or {}) do
        local door = ents.GetMapCreatedEntity(v[1])

        if IsValid(door) and door:IsDoor() then
            local lock = ents.Create("ix_combinelock")
            lock:SetPos(door:GetPos())
            lock:Spawn()
            lock:SetDoor(door, door:LocalToWorld(v[2]), door:LocalToWorldAngles(v[3]))
            lock:SetLocked(v[4])
        end
    end
end

function Schema:LoadForceFields()
    for _, v in ipairs(ix.data.Get("forceFields") or {}) do
        local field = ents.Create("ix_forcefield")
        field:SetPos(v[1])
        field:SetAngles(v[2])
        field:Spawn()
        field:SetMode(v[3])
    end
end

function Schema:SaveCombineLocks()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_combinelock")) do
        if IsValid(v.door) then
            data[#data + 1] = {v.door:MapCreationID(), v.door:WorldToLocal(v:GetPos()), v.door:WorldToLocalAngles(v:GetAngles()), v:GetLocked()}
        end
    end

    ix.data.Set("combineLocks", data)
end

function Schema:SaveForceFields()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_forcefield")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetMode()}
    end

    ix.data.Set("forceFields", data)
end