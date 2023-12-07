local PLUGIN = PLUGIN
PLUGIN.name = "Beating quota"
PLUGIN.author = "chatgpt"
PLUGIN.description = "beat ppl because hl2."

ix.util.Include("sv_hooks.lua")

ix.command.Add("ForceQuotaTarget", {
    description = "Force a quota target.",
    adminOnly = true,
    arguments = {
        ix.type.character,
        ix.type.string
    },
    OnRun = function(self, client, target, reason)
        if not reason then
            reason = "No reason given."
        end

        if target and IsValid(target:GetPlayer()) then -- check if target is a valid player character
            target:GetPlayer():Notify(client:Name() .. " has reset your beating quota. Reason: " .. reason)
            client:Notify("You have reset " .. target:GetName() .. "'s beating quota. Reason: " .. reason)
            target:GetPlayer():SetData("quota", 0)
            target:GetPlayer():SetData("quotamax", math.random(1, 9))
        else
            client:GetPlayer():Notify("Invalid target.")
        end
    end
})

PLUGIN.ResetQuotaTimer = ResetQuotaTimer


