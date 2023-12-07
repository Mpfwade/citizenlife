local PLUGIN = PLUGIN
PLUGIN.name     = 'Multiple Voice-lines'
PLUGIN.author   = 'Bilwin'
PLUGIN.version  = 1.12

if CLIENT then
    net.Receive('ixPlaySound', function()
        local sound = net.ReadString()
        local volume = net.ReadInt(32) if not volume || volume == 0 then volume = 80 end
        LocalPlayer():EmitSound(sound, volume)
    end)
end

ix.util.Include('sv_plugin.lua')