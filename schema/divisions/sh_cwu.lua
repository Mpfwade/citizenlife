ix.divisions.cwu = {}

ix.divisions.cwu[1] = {
    id = 1,
    name = "Unemployed",
    description = [[Name: Unemployed
Description: No Job.]],
    xp = 0,
    class = CLASS_CITIZEN,
    loadout = function(ply)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 0)
        ply:SetBodygroup(3, 0)
        ply:SetBodygroup(4, 0)
        ply:SetBodygroup(5, 0)
        ply:SetBodygroup(6, 0)
        ply:SetBodygroup(7, 0)
        ply:SetBodygroup(8, 0)
        ply:SetBodygroup(9, 0)
        ply:SetBodygroup(10, 0)
        ply:SetBodygroup(11, 0)
        ply:SetBodygroup(12, 0)
        ply:SetBodygroup(13, 0)
    end,
}

ix.divisions.cwu[2] = {
    id = 2,
    name = "Worker",
    description = [[Name: Worker
Description: A Standard City Worker, you are the lowest class job class. You maintain the streets and keep them clean and tidy. Sometimes you'll have to constuct something for the Combine.]],
    xp = 0,
    class = CLASS_CWU_WORKER,
    loadout = function(ply)
        ply:SetBodygroup(1, 7)
    end,
}

ix.divisions.cwu[3] = {
    id = 3,
    name = "Shop Owner",
    description = [[Name: Shop Owner
Description: A Shop Owner, you are capable of handing out food to random civilians whether it may be for tokens or for free.. up to you! You may open your own store to sell your Food with reasonable prices.]],
    xp = 5,
    class = CLASS_CWU_COOK,
    loadout = function(ply)
        local char = ply:GetCharacter()
        ply:SetBodygroup(1, 1)
        ply:SetBodygroup(2, 3)
        char:GiveFlags("p")
        char:GiveFlags("e")
        ply.noBusinessAllow = false
    end,
}


ix.divisions.cwu[4] = {
    id = 4,
    name = "Director",
    description = [[Name: Director
Description: The Director's job is to keep the all the workers in tip top shape, once in a while a City Administrator might come to your doorstep to see how thing's are going. ]],
    xp = 30,
    class = CLASS_CWU_DIRECTOR,
    loadout = function(ply)
        ply:SetBodygroup(1, 37)
        ply:SetBodygroup(2, 19)
    end,
}
