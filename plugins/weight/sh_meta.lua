-- ITEM META START --
local ITEM = ix.meta.item or {}

function ITEM:GetWeight()
	return self:GetData("weight", nil) or self.weight or nil
end

function ITEM:DropWeight(w)
	if (self.player) then
		local weight = w or self:GetWeight()

		if (weight) then
			self.player:GetCharacter():DropWeight(weight)
		end
	end
end

function ITEM:Remove(bNoReplication, bNoDelete)
    local inv = ix.inventory.Get(self.invID)
    local x2, y2

    if (inv) then
        if (self.invID ~= 0) then
            local failed = false

            for x = self.gridX, self.gridX + (self.width - 1) do
                if (inv.slots[x]) then
                    for y = self.gridY, self.gridY + (self.height - 1) do
                        local item = inv.slots[x][y]

                        if (item and item.id == self.id) then
                            inv.slots[x][y] = nil

                            x2 = x2 or x
                            y2 = y2 or y
                        else
                            failed = true
                        end
                    end
                end
            end

            if (failed) then
                local invW, invH = inv:GetSize()
                x2, y2 = nil, nil

                for x = 1, invW do
                    if (inv.slots[x]) then
                        for y = 1, invH do
                            local item = inv.slots[x][y]

                            if (item and item.id == self.id) then
                                inv.slots[x][y] = nil

                                x2 = x2 or x
                                y2 = y2 or y
                            end
                        end
                    end
                end
            end
        else
            ix.item.inventories[self.invID][self.id] = nil
        end
    end

    if (SERVER and !bNoReplication) then
        local entity = self:GetEntity()

        if (IsValid(entity)) then
            entity:Remove()
        end

        if (inv and inv.GetReceivers) then
            local receivers = inv:GetReceivers()

            if (self.invID ~= 0 and istable(receivers) and #receivers > 0) then
                net.Start("ixInventoryRemove")
                    net.WriteUInt(self.id, 32)
                    net.WriteUInt(self.invID, 32)
                net.Send(receivers)
            end
        end

        if (!bNoDelete) then
            local item = ix.item.instances[self.id]

            if (item and item.OnRemoved) then
                item:OnRemoved()
            end

            local query = mysql:Delete("ix_items")
                query:Where("item_id", self.id)
            query:Execute()

            ix.item.instances[self.id] = nil
        end
    end

    return x2, y2
end

ix.meta.item = ITEM
-- ITEM META END --

-- CHARACTER META START --
local CHAR = ix.meta.character or {}

function CHAR:Overweight()
	return self:GetData("carry", 0) > ix.weight.BaseWeight(self)
end

function CHAR:CanCarry(item)
	return ix.weight.CanCarry(item:GetWeight(), self:GetData("carry", 0), self)
end

function CHAR:UpdateWeight()
	ix.weight.Update(self)
end

-- these are primarily intended as internally used functions, you shouldn't use them in your own code --
function CHAR:AddCarry(item)
	self:SetData("carry", math.max(self:GetData("carry", 0) + item:GetWeight(), 0))
end

function CHAR:RemoveCarry(item)
	self:SetData("carry", math.max(self:GetData("carry", 0) - item:GetWeight(), 0))
end
-- these are primarily intended as internally used functions, you shouldn't use them in your own code --

function CHAR:DropWeight(weight)
	self:SetData("carry", math.max(self:GetData("carry", 0) - weight, 0))
end

ix.meta.char = CHAR
-- CHARACTER META END --
