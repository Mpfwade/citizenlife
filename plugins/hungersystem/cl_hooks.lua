local PLUGIN = PLUGIN or {}

function PLUGIN:RenderScreenspaceEffects()
    local character = LocalPlayer():GetCharacter()
	if LocalPlayer():IsCombine() then return end

    if character then
        local drunkEffect = character:GetDrunkEffect()

        if drunkEffect > 0 then
            DrawMotionBlur(0.075, drunkEffect, 0.025)
        end

        if character:GetData("Water", false) then
            DrawSharpen(5, 5)
        end
    end
end
