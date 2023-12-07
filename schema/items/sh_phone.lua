

ITEM.name = "Phone"
ITEM.model = Model("models/props/cs_office/phone.mdl")
ITEM.description = "A phone.\nIt is currently turned %s%s."
ITEM.cost = 50
ITEM.classes = {CLASS_EMP, CLASS_EOW}
ITEM.flag = "v"
ITEM.bDropOnDeath = true

-- Inventory drawing
if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("enabled")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end

function ITEM:GetDescription()
	local enabled = self:GetData("enabled")
	return string.format(self.description, enabled and "on" or "off", enabled and (" and tuned to " .. self:GetData("frequency", "100.000")) or "")
end

function ITEM.postHooks.drop(item, status)
	item:SetData("enabled", false)
end

ITEM.functions.Number = {
	OnRun = function(itemTable)
		netstream.Start(itemTable.player, "Frequency", itemTable:GetData("frequency", "000.000"))
        itemTable.player:EmitSound("bobcorp/phone/phone_dialup.wav")
		return false
	end
}

ITEM.functions.Toggle = {
	OnRun = function(itemTable)
		local character = itemTable.player:GetCharacter()
		local phones = character:GetInventory():GetItemsByUniqueID("phone", true)
		local bCanToggle = true

		-- don't allow someone to turn on another radio when they have one on already
		if (#phones > 1) then
			for k, v in ipairs(phones) do
				if (v != itemTable and v:GetData("enabled", false)) then
					bCanToggle = false
					break
				end
			end
		end

		if (bCanToggle) then
			itemTable:SetData("enabled", !itemTable:GetData("enabled", false))
			itemTable.player:EmitSound("bobcorp/phone/phone_dial_pickup.wav", 50, math.random(170, 180), 0.25)
		else
			itemTable.player:NotifyLocalized("phoneAlreadyOn")
		end

		return false
	end
}