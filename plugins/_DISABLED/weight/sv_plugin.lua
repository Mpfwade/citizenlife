function PLUGIN:OnCharacterCreated(client, character)
	character:SetData("additionalWeight", 0)
end

function PLUGIN:CharacterPreSave(character)
	local client = character:GetPlayer()

	if IsValid(client) then
		character:SetData("additionalWeight", character:GetData('additionalWeight'))
	end
end

function PLUGIN:CharacterLoaded(character)
	character:SetData("carry", ix.weight.CalculateWeight(character))
end

function PLUGIN:CanTransferItem(item, old, inv)
	if inv.owner and item:GetWeight() and (old and old.owner ~= inv.owner) then
		local character = ix.char.loaded[inv.owner]

		if not character:CanCarry(item) then
			character:GetPlayer():NotifyLocalized("You are carrying too much weight to take that.")

			return false
		end
	end
end

function PLUGIN:OnItemTransferred(item, old, new)
	if item:GetWeight() then
		if old.owner and not new.owner then
			ix.char.loaded[old.owner]:RemoveCarry(item)
		elseif not old.owner and new.owner then
			ix.char.loaded[new.owner]:AddCarry(item)
		elseif old.owner and new.owner and new['vars'].isBag then
			local inv = old:GetOwner():GetCharacter():GetInventory()
			inv:HasItem(new['vars'].isBag):SetData('weight', math.Clamp(inv:HasItem(new['vars'].isBag):GetData('weight', 0.1) + item:GetWeight(), 0, 10000))
		elseif old.owner and new.owner and old['vars'].isBag then
			local inv = old:GetOwner():GetCharacter():GetInventory()
			inv:HasItem(old['vars'].isBag):SetData('weight', math.Clamp(inv:HasItem(old['vars'].isBag):GetData('weight', 0.1) - item:GetWeight(), 0, 10000))
		end
	end
end

function PLUGIN:InventoryItemAdded(old, new, item)
	if item:GetWeight() then
		if not old and new.owner then
			ix.char.loaded[new.owner]:AddCarry(item)
		end
	end
end

function PLUGIN:CanPlayerTakeItem(client, item)
	local character = client:GetCharacter()
	local itm = item:GetItemTable()

	if itm:GetWeight() then
		if not character:CanCarry(itm) then
			client:NotifyLocalized("You are carrying too much weight to pick that up.")

			return false
		else
			return true
		end
	else
		return true
	end
end