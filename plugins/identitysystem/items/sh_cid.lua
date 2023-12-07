ITEM.name = "Identiband"
ITEM.model = Model("models/willardnetworks/misc/idcard.mdl")
ITEM.description = "A flat piece of plastic to locate your apartment and changes your status to an official citizen of the city. Reminder: The true citizen's identiband is kept clean and visible at all times.\n"
ITEM.category = "Other"
ITEM.noBusiness = true
ITEM.noDrop = true

function ITEM:GetDescription()
	return self.description
end

function ITEM:IsCombine()
	return self:GetData("cca", false)
end

function ITEM:GetModel()
	if self:IsCombine() then
		return "models/willardnetworks/misc/idcard.mdl"
	end
	
	return self.model
end

function ITEM:PopulateTooltip(tooltip)
	local data = tooltip:AddRow("data")	
	data:SetBackgroundColor(derma.GetColor("Info", data))
	data:SetText("Name: " .. self:GetData("citizen_name", "Unissued") .. 
	"\nID Number: " .. self:GetData("cid", "00000") .. 
	"\nApartment: " .. self:GetData("employment", "Homeless") ..
	"\nIssue Date: " .. self:GetData("issue_date", "Unissued"))

	data:SetFont("BudgetLabel")
	data:SetExpensiveShadow(0.5)
	data:SizeToContents()

	local warning = tooltip:AddRow("warning")
	warning:SetBackgroundColor(derma.GetColor("Error", tooltip))
	warning:SetText("Each card has an RFID chip and a photo of whoever was present at the time of it being issued.")
	warning:SetFont("DermaDefault")
	warning:SetExpensiveShadow(0.5)
	warning:SizeToContents()
end

ITEM.functions.ViewRecord = {
	name = "View Record",
	icon = "icon16/book_edit.png",
	OnRun = function(item)
		local client = item.player
		local target = nil

		for _, v in pairs(player.GetAll()) do
			if(v:GetCharacter() and v:GetCharacter():GetData("cid", "") == item:GetData("cid", 00000)) then
				target = v
				break
			end
		end

		if (target) then
			if(!hook.Run("CanPlayerViewData", client, target)) then
				client:Notify("@cantViewData")
				return false
			end
		else
			client:Notify("This character is not online or this is an invalid id.")		
			return false
		end

		local character = target:GetCharacter()
		
		if(character) then
			local data = character:GetData("record", {})
			local cid = character:GetData("cid", 00000)
	
			netstream.Start(client, "ixViewData", character:GetPlayer(), cid, data)
		end

		return false
	end,

	OnCanRun = function(item)
		return item.player:IsCombine() or item.invID != item.player:GetCharacter():GetInventory():GetID()
	end
}

function ITEM:OnEntityTakeDamage(ent, dmg)
    return false
end
