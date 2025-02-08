function ENT:Touch(otherEntity)
    if not IsValid(otherEntity) then return end

    print("Entity touched:", otherEntity)
    print("Entity class:", otherEntity:GetClass())

    -- Check if the entity is an ix_item
    if otherEntity:GetClass() == "ix_item" then
        -- Attempt to retrieve the item ID from NetVar
        local itemID = otherEntity:GetNetVar("id")
        print("Retrieved item ID from NetVar:", itemID)

        if itemID then
            -- Retrieve the item instance from Helix
            local itemTable = ix.item.instances[tonumber(itemID)]

            if itemTable then
                print("Helix item detected:", itemTable.uniqueID)

                -- Check if it's the specific item we want
                if itemTable.uniqueID == "sh_unfilbarrel" then
                    print("Barrel detected!")

                    -- Attach the item visually
                    otherEntity:SetParent(self)
                    otherEntity:SetLocalPos(Vector(0, 0, 50)) -- Adjust position
                    otherEntity:SetLocalAngles(Angle(0, 0, 0)) -- Adjust orientation

                    -- Simulate processing and remove the item
                    timer.Simple(4, function()
                        if IsValid(otherEntity) and itemTable then
                            itemTable:Remove() -- Properly remove the item from the inventory system
                            otherEntity:Remove() -- Remove the physical entity
                        end
                    end)
                end
            else
                print("Failed to find Helix item instance with ID:", itemID)
            end
        else
            print("No valid item ID found on this entity.")
        end
    else
        print("Touched entity is not an ix_item.")
    end
end