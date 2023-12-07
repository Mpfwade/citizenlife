local PLUGIN = PLUGIN
PLUGIN.name = "Hunger System"
PLUGIN.author = "Riggs Mackay"
PLUGIN.description = "Adds a Hunger System, simliar to the Apex Gamemode."

ix.config.Add("hungerTime", 120, "How many seconds between each time a player's needs are calculated", nil, {
    data = {
        min = 1,
        max = 600
    },
    category = "Hunger System"
})

ix.char.RegisterVar("hunger", {
    field = "hunger",
    fieldType = ix.type.number,
    default = 0,
    isLocal = true,
    bNoDisplay = true
})

ix.command.Add("CharSetHunger", {
    description = "Set character's hunger",
    privilege = "Manage Hunger System",
    arguments = {ix.type.character, bit.bor(ix.type.number, ix.type.optional)},
    OnRun = function(self, ply, char, level)
        if not ply:IsAdmin() then
            ply:Notify("Nice try.")

            return false
        end

        char:SetHunger(level or 0)
        ply:Notify(char:GetName() .. "'s hunger was set to " .. (level or 0))
    end
})

ix.command.Add("SetHunger", {
    description = "Set character's hunger",
    privilege = "Manage Hunger System",
    arguments = {ix.type.character, bit.bor(ix.type.number, ix.type.optional)},
    OnRun = function(self, ply, char, level)
        if not ply:IsAdmin() then return "Nice try." end
        char:SetHunger(level or 0)
        ply:Notify(char:GetName() .. "'s hunger was set to " .. (level or 0))
    end
})

ix.config.Add("enableAlcoholFallover", true, "Enable fall to the ground on the certain level of intoxication.", nil, {
    category = "Alcohol"
})

ix.config.Add("alcoholFallover", 5, "The level of intoxication on which player fall to the ground.", nil, {
    data = {min = 1, max = 50},
    category = "Alcohol"
})

do
    ix.char.RegisterVar("DrunkEffect", {
        field = "DrunkEffect",
        fieldType = ix.type.number,
        default = 0,
        bNoDisplay = true
    })

    ix.char.RegisterVar("DrunkEffectTime", {
        field = "DrunkEffectTime",
        fieldType = ix.type.number,
        default = 0,
        bNoDisplay = true
    })
end

ix.command.Add("AddDrunkEffect", {
    description = "Adds a drunk effect to character.",
    adminOnly = true,
    arguments = {
        ix.type.character,
        ix.type.number,
        ix.type.number,
    },
    OnRun = function(self, client, target, amount, duration)
        target:GetPlayer():AddDrunkEffect(amount, duration)
    end
})

ix.command.Add("RemoveDrunkEffect", {
    description = "Removes drunk effect from character.",
    adminOnly = true,
    arguments = {
        ix.type.character,
    },
    OnRun = function(self, client, target)
        target:GetPlayer():RemoveDrunkEffect()
    end
})

ix.util.Include("cl_hooks.lua")
ix.util.Include("sh_meta.lua")
ix.util.Include("sv_hooks.lua")