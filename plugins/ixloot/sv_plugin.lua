local PLUGIN = PLUGIN

-- messy but idc.
function PLUGIN:SearchLootContainer(ent, ply)
    if not (ply:IsCombine() or ply:IsDispatch()) then
        if not ent.containerAlreadyUsed or ent.containerAlreadyUsed <= CurTime() then
            -- support for my plugin
            if not (ply.isEatingConsumeable == true) then
                local randomChance = math.random(1, 20)
                local randomAmountChance = math.random(1, 4)
                local lootAmount = 1
                local randomLootItem = table.Random(PLUGIN.randomLoot.common)

                if randomAmountChance == 4 then
                    lootAmount = math.random(1, 4)
                else
                    lootAmount = 1
                end

                ply:EmitSound("physics/plastic/plastic_box_scrape_rough_loop1.wav", 35)
                ix.chat.Send(ply, "me", "goes through the trash, trying to find something useful.")
                ply:ForceSequence("roofidle1", nil, 1, false)
                ply:Freeze(true)

                ply:SetAction("Searching...", 1, function()
                    ply:Freeze(false)
                    ply:EmitSound("physics/plastic/plastic_box_impact_bullet1.wav")
                    ply:StopSound("physics/plastic/plastic_box_scrape_rough_loop1.wav")

                    for i = 1, lootAmount do
                        if randomChance == math.random(1, 20) then
                            randomLootItem = table.Random(PLUGIN.randomLoot.rare)
                            ply:ChatNotify("I found " .. ix.item.Get(randomLootItem):GetName() .. ".")
                            ply:GetCharacter():GetInventory():Add(randomLootItem)
                        else
                            randomLootItem = table.Random(PLUGIN.randomLoot.common)
                            ply:ChatNotify("I found " .. ix.item.Get(randomLootItem):GetName() .. ".")
                            ply:GetCharacter():GetInventory():Add(randomLootItem)
                        end
                    end
                end)

                ent.containerAlreadyUsed = CurTime() + 180
            else
                if not ent.ixContainerNotAllowedEat or ent.ixContainerNotAllowedEat <= CurTime() then
                    ply:ChatNotify("I cannot loot anything while I'm are eating!")
                    ent.ixContainerNotAllowedEat = CurTime() + 1
                end
            end
        else
            if not ent.ixContainerNothingInItCooldown or ent.ixContainerNothingInItCooldown <= CurTime() then
                ply:EmitSound("physics/plastic/plastic_box_scrape_rough_loop1.wav", 35)
                ply:ForceSequence("roofidle1", nil, 1, false)
                ply:Freeze(true)
                ply:SetAction("Searching...", 1, function()
                    ply:ChatNotify("I didn't find anything!")
                    ent.ixContainerNothingInItCooldown = CurTime() + 1
                    ply:Freeze(false)
                    ply:StopSound("physics/plastic/plastic_box_scrape_rough_loop1.wav")
                end)
            end
        end
    else
        if not ent.ixContainerNotAllowed or ent.ixContainerNotAllowed <= CurTime() then
            ply:ChatNotify("Your faction is not allowed to loot containers.")
            ent.ixContainerNotAllowed = CurTime() + 1
        end
    end
end

function Schema:SpawnRandomLoot(position, rareItem)
    local randomLootItem = table.Random(PLUGIN.randomLoot.common)

    if rareItem == true then
        randomLootItem = table.Random(PLUGIN.randomLoot.rare)
    end

    ix.item.Spawn(randomLootItem, position)
end