local PLUGIN = PLUGIN

function PLUGIN:SearchLootContainer(ent, ply)
    -- Check if the player is allowed to loot the container
    if ply:IsCombine() or ply:IsDispatch() then
        ply:ChatNotify("Your faction is not allowed to loot containers.")
        return
    end

    -- Check if the player is currently eating
    if ply.isEatingConsumeable then
        ply:ChatNotify("I cannot loot anything while I'm eating!")
        return
    end

    -- Check if the container is already used
    if ent.containerAlreadyUsed and ent.containerAlreadyUsed > CurTime() then
        ply:ChatNotify("I didn't find anything!")
        return
    end

    -- Determine the amount of loot
    local lootAmount = math.random(1, 4) == 4 and math.random(1, 4) or 1

    -- Determine the type of loot based on container type
    local containerClass = ent:GetClass()
    local lootType = (containerClass == "ix_loot_crate_404" or containerClass == "ix_loot_barrel_404" or containerClass == "ix_loot_dumpster_404") and PLUGIN.randomLoot.rare or PLUGIN.randomLoot.common

    -- Play search animations and sounds
    ply:EmitSound("physics/plastic/plastic_box_scrape_rough_loop1.wav", 35)
    ix.chat.Send(ply, "me", "goes through the trash, trying to find something useful.")
    ply:ForceSequence("roofidle1", nil, 1, false)
    ply:Freeze(true)

    -- Perform the search action
    ply:SetAction("Searching...", 1, function()
        ply:Freeze(false)
        ply:EmitSound("physics/plastic/plastic_box_impact_bullet1.wav")
        ply:StopSound("physics/plastic/plastic_box_scrape_rough_loop1.wav")

        for i = 1, lootAmount do
            local randomLootItem = table.Random(lootType)
            ply:ChatNotify("I found " .. ix.item.Get(randomLootItem):GetName() .. ".")
            ply:GetCharacter():GetInventory():Add(randomLootItem)
        end
    end)

    -- Set the cooldown for the container
    ent.containerAlreadyUsed = CurTime() + math.random(300, 600)
end


function Schema:SpawnRandomLoot(position, rareItem)
    local lootType = rareItem and PLUGIN.randomLoot.rare or PLUGIN.randomLoot.common
    local randomLootItem = table.Random(lootType)
    ix.item.Spawn(randomLootItem, position)
end
