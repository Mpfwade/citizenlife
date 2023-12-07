local PLUGIN = PLUGIN
PLUGIN.name = "Clockwork aim thing"
PLUGIN.description = "Makes s2k combat more fun"
PLUGIN.author = "Wade"

if not ( CLIENT ) then return end

local angleLerp
function PLUGIN:CalcView(ply, pos, ang, fov, nearZ, farZ)
    if ( IsValid(ix.gui.characterMenu) and not ix.gui.characterMenu:IsClosing() ) then return end
    if ( ply.ixRagdoll or ply.ixIntroState ) then return end
    if ( ix.option.Get("thirdpersonEnabled") ) then return end
    if ( ply:InVehicle() ) then return end

    local view = {
        origin = pos,
        angles = ang,
        fov = fov - 5,
    }

    if not ( angleLerp ) then
        angleLerp = ang
    end


    if ( IsValid(ply) and ply:Alive() and ply:IsWepRaised() ) and not ( ply:GetMoveType() == MOVETYPE_NOCLIP or ply.ixRagdoll ) then
        local ft = FrameTime()
        local rl = RealTime()

        angleLerp = LerpAngle(0.23, angleLerp, ang)
    else
        angleLerp = ang
    end

    view.angles = angleLerp

    return view
end

-- gay ppl