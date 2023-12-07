ITEM.name = "hOutfit"
ITEM.description = "A Better Outfit Base."
ITEM.category = "Outfit"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.outfitCategory = "model"
ITEM.pacData = {}

local function armorPlayer(client, target, amount)
    if client:Alive() and target:Alive() then
        target:SetArmor(amount)
    end
end

local function unarmorPlayer(client, target, amount)
    if client:Alive() and target:Alive() then
        target:SetArmor(target:Armor() - amount)
    end
end

if CLIENT then
    function ITEM:PaintOver(item, w, h)
        if item:GetData("equip") then
            surface.SetDrawColor(110, 255, 110, 100)
            surface.DrawRect(w - 14, h - 14, 8, 8)
        end
    end
end

function ITEM:RemoveOutfit(client)
    util.AddNetworkString("ixBandanaUnEquip")
    local character = client:GetCharacter()
    local fitArmor = self.fitArmor or 0
    self:SetData("equip", false)
    client:EmitSound("npc/combine_soldier/zipline_clothing" .. math.random(1, 2) .. ".wav")

    if character:GetData("oldModel" .. self.outfitCategory) then
        character:SetModel(character:GetData("oldModel" .. self.outfitCategory))
        character:SetData("oldModel" .. self.outfitCategory, nil)
    end

    if self.newSkin then
        if character:GetData("oldSkin" .. self.outfitCategory) then
            client:SetSkin(character:GetData("oldSkin" .. self.outfitCategory))
            character:SetData("oldSkin" .. self.outfitCategory, nil)
            character:SetData("skin", client:GetSkin())
        else
            client:SetSkin(0)
        end
    end

    for k, _ in pairs(self.bodyGroups or {}) do
        local index = client:FindBodygroupByName(k)

        if index > -1 then
            client:SetBodygroup(index, 0)
            local groups = character:GetData("groups", {})

            if groups[index] then
                groups[index] = nil
                character:SetData("groups", groups)
            end
        end
    end

    if character:GetData("oldGroups" .. self.outfitCategory) then
        for k, v in pairs(character:GetData("oldGroups" .. self.outfitCategory, {})) do
            client:SetBodygroup(k, v)
        end

        character:SetData("groups", character:GetData("oldGroups" .. self.outfitCategory, {}))
        character:SetData("oldGroups" .. self.outfitCategory, nil)
    end

    if self.attribBoosts then
        for k, _ in pairs(self.attribBoosts) do
            character:RemoveBoost(self.uniqueID, k)
        end
    end

    for k, _ in pairs(self:GetData("outfitAttachments", {})) do
        self:RemoveAttachment(k, client)
    end

    if fitArmor > 0 then
        local currentArmor = client:Armor()
        local armorToRemove = math.min(fitArmor, currentArmor)
        unarmorPlayer(client, client, armorToRemove)
        character:SetData(self.fitData, currentArmor - armorToRemove)
    end

    if self.name == "Bandana" and client:Alive() then
        local ply = self.player
        net.Start("ixBandanaUnEquip")
        net.Send(ply)
        ply.ixBandanaEquipped = nil
    end

    self:OnUnequipped()
end

function ITEM:AddAttachment(id)
    local attachments = self:GetData("outfitAttachments", {})
    attachments[id] = true
    self:SetData("outfitAttachments", attachments)
end

function ITEM:RemoveAttachment(id, client)
    local item = ix.item.instances[id]
    local attachments = self:GetData("outfitAttachments", {})

    if item and attachments[id] then
        item:OnDetached(client)
    end

    attachments[id] = nil
    self:SetData("outfitAttachments", attachments)
end

ITEM:Hook("drop", function(item)
    if item:GetData("equip") then
        item:RemoveOutfit(item:GetOwner())
    end
end)

ITEM.functions.EquipUn = {
    name = "Unequip",
    tip = "equipTip",
    icon = "icon16/cross.png",
    OnRun = function(item)
        item:RemoveOutfit(item.player)

        return false
    end,
    OnCanRun = function(item)
        local client = item.player

        return not IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and hook.Run("CanPlayerUnequipItem", client, item) ~= false and item.invID == client:GetCharacter():GetInventory():GetID()
    end
}

ITEM.functions.Equip = {
    name = "Equip",
    tip = "equipTip",
    icon = "icon16/tick.png",
    OnRun = function(item)
        util.AddNetworkString("ixBandanaEquip")
        local client = item.player
        local char = client:GetCharacter()
        local items = char:GetInventory():GetItems()

        if client.isEquipingOutfit == true then
            client:ChatPrint("I can only put on one piece of clothing at a time.")

            return false
        end

        client:EmitSound("npc/combine_soldier/zipline_clothing" .. math.random(1, 2) .. ".wav")
        client:ForceSequence("photo_react_startle", nil, 0.85, false)
        client.isEquipingOutfit = true

        timer.Simple(0.85, function()
            client:LeaveSequence()
            client.isEquipingOutfit = false
        end)

        for _, v in pairs(items) do
            if v.id ~= item.id then
                local itemTable = ix.item.instances[v.id]

                if itemTable.pacData and v.outfitCategory == item.outfitCategory and itemTable:GetData("equip") then
                    client:NotifyLocalized(item.equippedNotify or "outfitAlreadyEquipped")

                    return false
                end
            end
        end

        item:SetData("equip", true)

        if isfunction(item.OnGetReplacement) then
            char:SetData("oldModel" .. item.outfitCategory, char:GetData("oldModel" .. item.outfitCategory, item.player:GetModel()))
            char:SetModel(item:OnGetReplacement())
        elseif item.replacement or item.replacements then
            char:SetData("oldModel" .. item.outfitCategory, char:GetData("oldModel" .. item.outfitCategory, item.player:GetModel()))

            if istable(item.replacements) then
                if #item.replacements == 2 and isstring(item.replacements[1]) then
                    char:SetModel(item.player:GetModel():gsub(item.replacements[1], item.replacements[2]))
                else
                    for _, v in ipairs(item.replacements) do
                        char:SetModel(item.player:GetModel():gsub(v[1], v[2]))
                    end
                end
            else
                char:SetModel(item.replacement or item.replacements)
            end
        end

        if item.newSkin then
            char:SetData("oldSkin" .. item.outfitCategory, item.player:GetSkin())
            char:SetData("skin", item.newSkin)
            item.player:SetSkin(item.newSkin)
        end

        local groups = char:GetData("groups", {})

        if not table.IsEmpty(groups) then
            char:SetData("oldGroups" .. item.outfitCategory, groups)

            if not item.noResetBodyGroups then
                client:ResetBodygroups()
            end
        end

        if item.bodyGroups then
            groups = {}

            for k, value in pairs(item.bodyGroups) do
                local index = item.player:FindBodygroupByName(k)

                if index > -1 then
                    groups[index] = value
                end
            end

            local newGroups = char:GetData("groups", {})

            for index, value in pairs(groups) do
                newGroups[index] = value
                item.player:SetBodygroup(index, value)
            end

            if not table.IsEmpty(newGroups) then
                char:SetData("groups", newGroups)
            end
        end

        if item.attribBoosts then
            for k, v in pairs(item.attribBoosts) do
                char:AddBoost(item.uniqueID, k, v)
            end
        end

        if item.fitArmor then
            armorPlayer(item.player, item.player, item.fitArmor + client:Armor())
            char:SetData(item.fitData, item.fitArmor + client:Armor())
            char:SetData("armor", math.Clamp(item.player:Armor(), 0, item.fitArmor))
        end

        if item.name == "Bandana" then
            local ply = item.player
            net.Start("ixBandanaEquip")
            net.Send(ply)
            ply.ixBandanaEquipped = true
        end

        item:OnEquipped()

        return false
    end,
    OnCanRun = function(item)
        local client = item.player
        if item.allowedModels and not table.HasValue(item.allowedModels, item.player:GetModel()) then return false end

        return not IsValid(item.entity) and IsValid(client) and item:GetData("equip") ~= true and item:CanEquipOutfit() and hook.Run("CanPlayerEquipItem", client, item) ~= false and item.invID == client:GetCharacter():GetInventory():GetID()
    end
}

function ITEM:CanTransfer(oldInventory, newInventory)
    if newInventory and self:GetData("equip") then return false end

    return true
end

function ITEM:OnRemoved()
    if self.invID ~= 0 and self:GetData("equip") then
        self.player = self:GetOwner()
        self:RemoveOutfit(self.player)
        self.player = nil
    end
end

function ITEM:OnEquipped()
end

function ITEM:OnUnequipped()
end

function ITEM:CanEquipOutfit()
    return true
end

if SERVER then
    net.Receive("ixBandanaEquip", function()
        LocalPlayer().ixBandanaEquipped = true
    end)

    net.Receive("ixBandanaUnEquip", function()
        LocalPlayer().ixBandanaEquipped = nil
    end)
end

function ITEM:OnLoadout()
    local char = self.player:GetCharacter()
    if char:GetInventory() then
        local equippedItems = char:GetInventory():GetItems()

        for _, item in ipairs(equippedItems) do
            if item.Category == "Armor Items" and item:GetData("equip") == true then
                armorPlayer(self.player, self.player, item.fitArmor + self.player:Armor())
            end
        end
    end
end
