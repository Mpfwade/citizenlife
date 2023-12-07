local PLUGIN = PLUGIN
local sW = ScrW()

function PLUGIN:HUDPaint()
    local ply = LocalPlayer()
    local char = ply:GetCharacter()

    if ply:IsValid() and ply:Alive() and char then
        if (ix.hudEnabled == false) or (ix.CinematicIntro and ply:Alive()) or ply.ixIntroBool or (IsValid(ix.gui.menu) or IsValid(ix.gui.characterMenu)) or (hook.Run("ShouldDrawHUDBox") == false) then
            if IsValid(PlayerIcon) then
                PlayerIcon:Remove()
            end

            return false
        end

        if ply:IsCombine() and not (ply.adminHud == true) then
            local font = "CLCHud1"
            local ply = LocalPlayer()

            -- Compatibility with one of my other plugins
            if ix.plugin.Get("chud") then
                font = "CLCHud1"
            end

            if LocalPlayer():IsCombine() then
                draw.SimpleTextOutlined("<:: CURRENT ASSIGNMENT: " .. self:GetEvent() .. " ::>", font, sW / 2, 65, Color(0, 138, 216), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
            end
        end
    end

    -- Don't know who would change their screen size while in game but you never know
    function PLUGIN:OnScreenSizeChanged()
        sW = ScrW()
    end
end