--[[---------------------------------------------------------------------------
	Character Meta Functions
---------------------------------------------------------------------------]]--

local CHAR = ix.meta.character

function CHAR:GiveMoney(amount)
	self:SetMoney(self:GetMoney() + amount)
end

function CHAR:HasMoney(amount)
	if (amount < 0) then
		print("Negative Money Check Received.")
	end

	return self:GetMoney() >= amount
end

function CHAR:TakeMoney(amount)
	if self:HasMoney(amount) then
		self:GiveMoney(-amount)
	end
end

function CHAR:GetBankedMoney()
	return self:GetData("ixBankedMoney", 0)
end

function CHAR:GetSalary()
	local faction = self:GetFaction()

	local factionTab = ix.faction.indices[faction]

	if not factionTab then
		return 0
	end

	if not factionTab.pay then
		return 0
	end

	return factionTab.pay
end
