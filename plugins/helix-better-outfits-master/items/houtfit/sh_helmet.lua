ITEM.name = "Canvas Helmet"
ITEM.description = "An Old Pre-War Canvas Helmet."
ITEM.model = "models/props_junk/cardboard_box003b.mdl"
ITEM.outfitCategory = "helmet"
ITEM.noResetBodyGroups = true
ITEM.bDropOnDeath = true
ITEM.headcrabHits = 3 -- Number of hits this helmet provides

ITEM.bodyGroups = {
    ["Headgear"] = 12
}

ITEM.height = 1
ITEM.width = 1
ITEM.category = "Clothes/Outfits"
ITEM.fitHelmet = 15

ITEM.allowedModels = {
    "models/humans/pandafishizens/female_01.mdl",
    "models/humans/pandafishizens/female_02.mdl",
    "models/humans/pandafishizens/female_03.mdl",
    "models/humans/pandafishizens/female_04.mdl",
    "models/humans/pandafishizens/female_06.mdl",
    "models/humans/pandafishizens/female_07.mdl",
    "models/humans/pandafishizens/female_11.mdl",
    "models/humans/pandafishizens/female_17.mdl",
    "models/humans/pandafishizens/female_18.mdl",
    "models/humans/pandafishizens/female_19.mdl",
    "models/humans/pandafishizens/female_24.mdl",
    "models/humans/pandafishizens/female_25.mdl",
    "models/humans/pandafishizens/male_01.mdl",
    "models/humans/pandafishizens/male_02.mdl",
    "models/humans/pandafishizens/male_03.mdl",
    "models/humans/pandafishizens/male_04.mdl",
    "models/humans/pandafishizens/male_05.mdl",
    "models/humans/pandafishizens/male_06.mdl",
    "models/humans/pandafishizens/male_07.mdl",
    "models/humans/pandafishizens/male_08.mdl",
    "models/humans/pandafishizens/male_09.mdl",
    "models/humans/pandafishizens/male_10.mdl",
    "models/humans/pandafishizens/male_11.mdl",
    "models/humans/pandafishizens/male_12.mdl",
    "models/humans/pandafishizens/male_15.mdl"
}

function ITEM:OnEquipped()
    self:SetData("equip", true)
    local client = self.player
    local char = client:GetCharacter()
    
    char:SetData("headcrabHitsRemaining", self.headcrabHits)
    client:ChatPrint("Canvas Helmet equipped. Headcrab hits remaining: " .. self.headcrabHits)
end

function ITEM:OnUnequipped()
    self:SetData("equip", false)
    local client = self.player
    local char = client:GetCharacter()

    char:SetData("headcrabHitsRemaining", 1) -- Reset to default
    client:ChatPrint("Canvas Helmet unequipped. Headcrab hits reset.")
end