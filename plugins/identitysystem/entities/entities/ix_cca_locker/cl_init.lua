include("shared.lua")

net.Receive("FactionChangeFade", function()
    local fadeOut = net.ReadBool()
    local alpha = fadeOut and 0 or 255
    local fadeSpeed = 500 / 7  -- Adjust this for a longer fade duration

    hook.Add("HUDPaint", "FadeToBlack", function()
        if fadeOut then
            alpha = math.min(alpha + FrameTime() * fadeSpeed, 500)
        else
            alpha = math.max(alpha - FrameTime() * fadeSpeed, 0)
        end

        surface.SetDrawColor(0, 0, 0, alpha)
        surface.DrawRect(0, 0, ScrW(), ScrH())

        if (fadeOut and alpha >= 500) or (not fadeOut and alpha <= 0) then
            hook.Remove("HUDPaint", "FadeToBlack")
        end
    end)
end)