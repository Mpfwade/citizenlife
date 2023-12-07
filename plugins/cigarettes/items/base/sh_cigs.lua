ITEM.name = "Cigarette"
ITEM.description = "A cigarette base based on the PAC base."
ITEM.category = "Outfit"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.outfitCategory = "hat"
ITEM.pacData = {}

-- Inventory drawing
if CLIENT then
    -- Draw camo if it is available.
    function ITEM:PaintOver(item, w, h)
        if item:GetData("smoking") then
            surface.SetDrawColor(110, 255, 110, 100)
            surface.DrawRect(w - 14, h - 14, 8, 8)
        end
    end
end

function ITEM:RemovePart(client)
    local char = client:GetCharacter()
    self:SetData("smoking", false)
    client:RemovePart(self.uniqueID)
	
    if self.attribBoosts then
        for k, _ in pairs(self.attribBoosts) do
            char:RemoveBoost(self.uniqueID, k)
        end
    end

    self:OnUnequipped()
end

-- On item is dropped, remove the smoking part from the player.
ITEM:Hook("drop", function(item)
    if item:GetData("smoking") then
        item:RemovePart(item.player)
    end
end)

-- On player unequips the item, remove the smoking part from the player.
ITEM.functions.stubOut = {
    name = "Stub out",
    tip = "stubOut",
    icon = "icon16/cancel.png",
    OnRun = function(item)
        item:RemovePart(item.player)

        return true
    end,
    OnCanRun = function(item)
        local client = item.player

        return not IsValid(item.entity) and IsValid(client) and item:GetData("smoking") == true and hook.Run("CanPlayerUnequipItem", client, item) ~= false and item.invID == client:GetCharacter():GetInventory():GetID()
    end
}

-- On player equips the item, start smoking.
ITEM.functions.Smoke = {
    name = "Smoke",
    tip = "smokeTip",
    icon = "icon16/tick.png",
    OnRun = function(item)
        local char = item.player:GetCharacter()
        local items = char:GetInventory():GetItems()

        for _, v in pairs(items) do
            if v.id ~= item.id then
                local itemTable = ix.item.instances[v.id]

                if itemTable.pacData and v.outfitCategory == item.outfitCategory and itemTable:GetData("smoking") then
                    item.player:Notify("You're smoking right now!")

                    return false
                end
            end
        end

        if item.addiction then
            local lastUse = char:GetData("drug_use_" .. item.uniqueID, os.time())

            -- 2 hours
            if os.time() - lastUse < 3600 then
                local addictionChance = math.random(1, 100)

                if addictionChance < item.addictionChance then
                    local curAddiction = char:GetData("addictions", {})
                    curAddiction[item.uniqueID] = true
                    char:SetData("addictions", curAddiction)
                end
            end
        end

        item:SetData("smoking", true)
        item.player:AddPart(item.uniqueID, item)

        if item.attribBoosts then
            for k, v in pairs(item.attribBoosts) do
                char:AddBoost(item.uniqueID, k, v)
            end
        end

        timer.Create("SmokeTimer", 300, 1, function()
            item:EndSmoke()
        end)

        return false
    end,
    OnCanRun = function(item)
        local client = item.player
        local items = client:GetCharacter():GetInventory()

        if items:HasItem("lighter") then
            return not IsValid(item.entity) and IsValid(client) and item:GetData("smoking") ~= true and hook.Run("CanPlayerEquipItem", client, item) ~= false and item.invID == client:GetCharacter():GetInventory():GetID()
        else
            item.player:Notify("You don't own a lighter!")

            return false
        end
    end
}

function ITEM:CanTransfer(oldInventory, newInventory)
    if newInventory and self:GetData("equip") then return false end

    return true
end

function ITEM:OnRemoved()
    local inventory = ix.item.inventories[self.invID]
    local owner = inventory.GetOwner and inventory:GetOwner()

    if IsValid(owner) and owner:IsPlayer() then
        if self:GetData("smoking") then
            self:RemovePart(owner)
            self:Remove()
        end
    end
end

function ITEM:OnEquipped()
end

function ITEM:EndSmoke()
    local owner = self.player

    if owner:Alive() then
        self:Remove()
        self:RemovePart(owner)
    end
end

function ITEM:OnUnequipped()
end

hook.Add("PlayerDeath", "Cigg", function(ply)
    if timer.Exists("SmokeTimer") then
        timer.Remove("SmokeTimer")
    end
end)
