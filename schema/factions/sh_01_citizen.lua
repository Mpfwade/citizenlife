--[[ Base Config ]]
--
FACTION.name = "Citizen"
FACTION.description = [[Name: Citizen
Description: The lowest class of Universal Union society. They are forced to follow the Universal Union's dictatorship with absolute obedience, or face punishments and even execution. The Universal Union keeps citizens weak and malnourished, and it is all they can do to try and survive. However, some brave citizens dare to stand against the Combine...]]
FACTION.color = Color(101,56,24)

--[[ Helix Base Config ]]
--
FACTION.models = {
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

FACTION.isGloballyRecognized = false
FACTION.isDefault = true
FACTION.payTime = 600
FACTION.pay = 0

function FACTION:OnCharacterCreated(client, character)
    local id = Schema:ZeroNumber(math.random(1, 99999), 5)
    local inventory = character:GetInventory()
    character:SetData("cid", id)
    inventory:Add("suitcase", 1)
    inventory:Add("supplements", 1)
    inventory:Add("water", 1)

    inventory:Add("transfer_papers", 1, {
        citizen_name = character:GetName(),
        cid = character:GetData("cid", id),
        unique = math.random(0000000, 999999999),
        issue_date = ix.date.GetFormatted("%A, %B %d, %Y. %H:%M:%S"),
    })
end

--[[ Custom Config ]]
--
FACTION.voicelinesHuman = true
FACTION.defaultClass = nil
FACTION.adminOnly = false
FACTION.donatorOnly = false
FACTION.noModelSelection = true
FACTION.requiredXP = nil
FACTION.command = "ix_faction_become_citizen"
FACTION.modelWhitelist = "humans/pandafishizens"
--[[ Do not change! ]]
--
FACTION_CITIZEN = FACTION.index