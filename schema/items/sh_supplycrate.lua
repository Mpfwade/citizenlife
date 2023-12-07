-- Made by silas AND KRAFTY

ITEM.name = "Supply crate"
ITEM.description = "A crate that holds goodies."
-- Item Configuration
ITEM.model = "models/Items/item_item_crate.mdl"
ITEM.skin = 0
ITEM.noBusiness = true
ITEM.exRender = true
ITEM.bDropOnDeath = true
ITEM.width = 1
ITEM.height = 1

ITEM.iconCam = {
    pos = Vector(1.96, 5.95, 199.77),
    ang = Angle(86.31, 276.88, 0),
    fov = 6.82
}

ITEM.items = {
    {
        name = "pistol ammo",
        itemClass = "pistolammo",
        rarity = 65, -- Lower rarity
    },

    {
        name = "smg ammo",
        itemClass = "smg1ammo",
        rarity = 40, -- Lower rarity
    },

    {
        name = "shotgunammo",
        itemClass = "shotgunammo",
        rarity = 25, -- Lower rarity
    },

    {
        name = "357",
        itemClass = "357ammo",
        rarity = 10, -- Lower rarity
    },

    {
        name = "SMG",
        itemClass = "mp7",
        rarity = 15, -- Higher rarity
    },
    
    {
        name = "Pistol",
        itemClass = "usp",
        rarity = 20, -- Lower rarity
    },

    {
        name = "Shotgun",
        itemClass = "spas12",
        rarity = 10, -- Lower rarity
    },

    {
        name = "Axe",
        itemClass = "axe",
        rarity = 75, -- Lower rarity
    },

    {
        name = "Molotov",
        itemClass = "molotov",
        rarity = 60, -- Lower rarity
    },

    {
        name = "EMP",
        itemClass = "emp",
        rarity = 1, -- Lower rarity
    },

    {
        name = "Blue Resistance Shirt with Vest",
        itemClass = "brebelshirt1",
        rarity = 40, -- Lower rarity
    },

    {
        name = "Green Resistance Shirt with Vest",
        itemClass = "grebelshirt1",
        rarity = 40, -- Lower rarity
    },

    {
        name = "Nade",
        itemClass = "grenade",
        rarity = 75, -- Lower rarity
    },

    {
        name = "katana",
        itemClass = "katana",
        rarity = 5, -- Lower rarity
    },

    {
        name = "pickaxe",
        itemClass = "pickaxe",
        rarity = 68, -- Lower rarity
    },

    {
        name = "stunstick",
        itemClass = "stunstick",
        rarity = 55, -- Lower rarity
    },

}


ITEM.functions.Open = {
    icon = "icon16/box.png",
    OnRun = function(itemTable)
        local ply = itemTable.player 

        -- Calculate total rarity points
        local totalRarity = 0
        for _, item in ipairs(itemTable.items) do
            totalRarity = totalRarity + item.rarity
        end

        local selectedItems = {}

        for i = 1, 3 do
            -- Generate a random number between 1 and totalRarity
            local randomValue = math.random(totalRarity)

            -- Select an item based on the random value and rarity
            local selectedItem
            local cumulativeRarity = 0
            for _, item in ipairs(itemTable.items) do
                cumulativeRarity = cumulativeRarity + item.rarity
                if randomValue <= cumulativeRarity then
                    selectedItem = item
                    break
                end
            end

            if selectedItem then
                -- Check if the selected item is already in the list of selected items
                local isDuplicate = false
                for _, existingItem in ipairs(selectedItems) do
                    if existingItem.itemClass == selectedItem.itemClass then
                        isDuplicate = true
                        break
                    end
                end

                if not isDuplicate then
                    table.insert(selectedItems, selectedItem)
                    totalRarity = totalRarity - selectedItem.rarity
                end
            end
        end

        if #selectedItems == 0 then
            return false -- No items were selected, return false to indicate failure
        end

        -- Give the player the selected items
        local character = ply:GetCharacter()
        local inventory = character:GetInventory()
        for _, item in ipairs(selectedItems) do
            inventory:Add(item.itemClass, 1)
        end

        return true -- Return true to indicate successful execution of the function
    end
}


function ITEM:OnEntityTakeDamage(ent, dmg)
    return false
end
