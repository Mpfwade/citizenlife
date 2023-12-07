ix.ranks.cca = {}

ix.ranks.cca[1] = {
    id = 1,
    name = "BASIC-UNIT",
    description = "Gets a stunstick",
    xp = 0,
    health = 0,
    armor = 0,
    class = CLASS_CCA_BASICUNIT,
    loadout = function(ply)
        local char = ply:GetCharacter()
        local inventory = char:GetInventory()

        if not inventory:HasItem("stunstick") then
            if ply:GetNWBool("CPRespawn", true) == true then
                ply:SetNWBool("CPRespawn", false)
                inventory:Add("stunstick")
            end
        end
    end,
}

ix.ranks.cca[2] = {
    id = 1,
    name = "GROUND-UNIT",
    description = "Gets a stunstick and a pistol",
    xp = 5,
    health = 0,
    armor = 0,
    class = CLASS_CCA_GROUNDUNIT,
    loadout = function(ply)
        local char = ply:GetCharacter()
        local inventory = char:GetInventory()

        if not inventory:HasItem("stunstick") or not inventory:HasItem("usp") then
            if ply:GetNWBool("CPRespawn", true) == true then
                ply:SetNWBool("CPRespawn", false)
                inventory:Add("stunstick")
                inventory:Add("usp")
            end
        end
    end,
}

ix.ranks.cca[3] = {
    id = 1,
    name = "ADVANCED-UNIT",
    description = "Gets a stunstick, pistol and SMG",
    xp = 20,
    health = 0,
    armor = 0,
    class = CLASS_CCA_ADVUNIT,
    loadout = function(ply)
        local char = ply:GetCharacter()
        local inventory = char:GetInventory()

        if not inventory:HasItem("stunstick") or not inventory:HasItem("usp") or not inventory:HasItem("smg") then
            if ply:GetNWBool("CPRespawn", true) == true then
                ply:SetNWBool("CPRespawn", false)
                inventory:Add("stunstick")
                inventory:Add("usp")
                inventory:Add("smg")
            end
        end
    end,
}

ix.ranks.cca[4] = {
    id = 11,
    name = "RL",
    description = "Leader who can lead PTs",
    xp = nil,
    health = 0,
    armor = 0,
    class = CLASS_CCA_RL,
    loadout = function(ply)
        local char = ply:GetCharacter()
        local inventory = char:GetInventory()

        if not inventory:HasItem("stunstick") or not inventory:HasItem("usp") or not inventory:HasItem("smg") then
            if ply:GetNWBool("CPRespawn", true) == true then
                ply:SetNWBool("CPRespawn", false)
                inventory:Add("stunstick")
                inventory:Add("usp")
                inventory:Add("smg")
            end
        end
    end,
}

ix.divisions.cca = {}

ix.divisions.cca[1] = {
    id = 1,
    name = "Civil Protection Officer",
    description = "The Standard Civil Protection Officer",
    norank = false,
    skin = 0,
    weapons = {},
    health = 100,
    armor = 45,
    max = 6,
    xp = 0,
    class = CLASS_CCA_UNION,
}