PLUGIN.name = "Passive Dispatch"
PLUGIN.description = "Automatic dispatch"
PLUGIN.author = "Stalker"

ix.util.Include("sv_hooks.lua")

concommand.Add("ix_dev_getpos", function(ply)
    local pos = ply:GetPos()
    local introDetails = "Vector("..pos.x..", "..pos.y..", "..pos.z..")"

    print(introDetails)
end)

