ix.weight = ix.weight or {}

function ix.weight.WeightString(weight, imperial)
    if imperial then
        -- Filthy imperial system; Why do I allow their backwards thinking?
        if weight < 0.453592 then
            return math.Round(weight * 35.274, 2) .. " oz"
        else
            return math.Round(weight * 2.20462, 2) .. " lbs"
        end
    else
        -- The superior units of measurement.
        if weight < 1 then
            return math.Round(weight * 1000, 2) .. " g"
        else
            return math.Round(weight, 2) .. " kg"
        end
    end
end

function ix.weight.CanCarry(weight, carry)
    local max = ix.config.Get("maxWeight", 30) + ix.config.Get("maxOverWeight", 30)

    return (weight + carry) <= max
end

function PLUGIN:CanTransferItem(itemObject, curInv, inventory)
    if SERVER then
        local client = itemObject.GetOwner and itemObject:GetOwner() or nil
        client:ChatPrint("RAN CAN TRANSFER")

        if IsValid(client) and curInv.GetReceivers then
            local bAuthorized = false

            for _, v in ipairs(curInv:GetReceivers()) do
                if client == v then
                    bAuthorized = true
                    break
                end
            end

            if not bAuthorized then return false end
        end
    end

    -- we can transfer anything that isn't a bag
    if not itemObject or not itemObject.isBag then return end

    -- don't allow bags to be put inside bags
    if inventory.id ~= 0 and curInv.id ~= inventory.id then
        if inventory.vars and inventory.vars.isBag then
            local owner = itemObject:GetOwner()

            if IsValid(owner) then
                owner:NotifyLocalized("nestedBags")
            end

            return false
        end
    elseif inventory.id ~= 0 and curInv.id == inventory.id then
        -- we are simply moving items around if we're transferring to the same inventory
        return
    end

    inventory = ix.item.inventories[itemObject:GetData("id")]

    -- don't allow transferring items that are in use
    if inventory then
        for _, v in pairs(inventory:GetItems()) do
            if v:GetData("equip") == true then
                local owner = itemObject:GetOwner()

                if owner and IsValid(owner) then
                    owner:NotifyLocalized("equippedBag")
                end

                return false
            end
        end
    end

    if SERVER then
        local client = itemObject.GetOwner and itemObject:GetOwner() or nil
        if not client:GetCharacter():CanCarry(itemObject:GetWeight()) then return false end
    end

    return true
end