ITEM.name = "Identiband/Apartment card"
ITEM.uniqueID = "apartment_card"
ITEM.description = "A flat piece of plastic to locate your apartment and changes your status to an official citizen of the city. Reminder: The true citizen's identiband is kept clean and visible at all times."
ITEM.model = "models/willardnetworks/misc/idcard.mdl"
ITEM.factions = {FACTION_CP, FACTION_ADMIN}
ITEM.functions.Assign = {

	OnRun = function(item)
		netstream.Start(item.player, "ApartmentsCardAdmSetup", item:GetID())

		return false
	end,
	OnCanRun = function(item)
		return item.player:IsCombine()
	end
}

--[[	OnRun = function(item)
		local data = {}
			data.start = item.player:EyePos()
			data.endpos = data.start + item.player:GetAimVector()*96
			data.filter = item.player
		local entity = util.TraceLine(data).Entity

		if (IsValid(entity) and entity:IsPlayer() and entity:Team() == FACTION_CITIZEN) then
			netstream.Start(item.player, "ApartmentsCardSetup", item:GetID(), entity)
		end

		return false
	end,
	OnCanRun = function(item)
		return item.player:IsCombine()
	end
}
--]]
ITEM.functions.AdmAssign = {
	OnRun = function(item)
		netstream.Start(item.player, "ApartmentsCardAdmSetup", item:GetID())

		return false
	end,
	OnCanRun = function(item)
		return item.player:IsAdmin()
	end
}

function ITEM:GetDescription()
	local description = self.description.."\nThis apartments card is assigned to apartment #"..self:GetData("apartment", "000").."."

	return description
end

if CLIENT then
	netstream.Hook("ApartmentsCardSetup", function(itemID, ply)
		Derma_StringRequest("What Apartment do you want to assign to this card?", "Setup Apartments Card", "400", function(text)
			netstream.Start("ApartmentsCardSetup", itemID, ply, text)
		end)
	end)
	netstream.Hook("ApartmentsCardAdmSetup", function(itemID)
		Derma_StringRequest("What Apartment do you want to assign to this card?", "Setup Apartments Card", "400", function(text)
			netstream.Start("ApartmentsCardAdmSetup", itemID, text)
		end)
	end)
else
	netstream.Hook("ApartmentsCardSetup", function(ply, itemID, receiver, apart)
		if (!IsValid(receiver) or !receiver:IsPlayer() or receiver:Team() != FACTION_CITIZEN) then return end

		local item
		for k, v in pairs(ply:GetChar():GetInv():GetItems()) do
			if v:GetID() == itemID then
				item = v
				break
			end
		end

		if (item.uniqueID != "apartment_card") then return end
		if (!table.HasValue(item.factions, ply:Team())) then return end

		local status, result = item:Transfer(receiver:GetChar():GetInv():GetID())
		if (status) then
			item:SetData("apartment", apart)

			return true
		else
			item.player:Notify(result)
		end
	end)

	netstream.Hook("ApartmentsCardAdmSetup", function(ply, itemID, apart)
		local item
		for k, v in pairs(ply:GetChar():GetInv():GetItems()) do
			if v:GetID() == itemID then
				item = v
				break
			end
		end

		if (item.uniqueID != "apartment_card") then return end

		item:SetData("apartment", apart)
	end)
end
