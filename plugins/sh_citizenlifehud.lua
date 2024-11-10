local PLUGIN = PLUGIN

if CLIENT then
    local surface = surface
    local combatWeapons = {
        ["ls_pistol"] = "USP",
        ["ls_smg"] = "SMG",
        ["ls_357mag"] = "357",
        ["ix_spas12"] = "SPAS-12",
        ["ls_ar2"] = "OSIPR",
    }

    local letterBoxFade = 0
    local letterBoxTitleFade = 0
    local letterBoxHoldTime = nil
    ix.CinematicholdTime = 10

    local colorModifyStorm = {
        ["$pp_colour_addr"] = 0,
        ["$pp_colour_addg"] = 0.1,
        ["$pp_colour_addb"] = 0.2,
        ["$pp_colour_brightness"] = 1,
        ["$pp_colour_contrast"] = 1,
        ["$pp_colour_colour"] = 1,
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 1,
        ["$pp_colour_mulb"] = 1
    }

    local colorModify = {
        ["$pp_colour_addr"] = 0,
        ["$pp_colour_addg"] = 0,
        ["$pp_colour_addb"] = 0,
        ["$pp_colour_brightness"] = 0,
        ["$pp_colour_contrast"] = 1,
        ["$pp_colour_colour"] = 0.7,
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 0,
        ["$pp_colour_mulb"] = 0
    }

    ix.config.Add("enableHaloEffects", true, "Whether to enable halo effects for doors and items.", nil, {
        category = "Halo Effects"
    })

    ix.option.Add("enableHaloEffects", ix.type.bool, true, {
        category = "Halo Effects"
    })

    function PLUGIN:PreDrawHalos()
        if not ix.config.Get("enableHaloEffects", true) then return end
        if not ix.option.Get("enableHaloEffects", true) then return end

        local ply = LocalPlayer()
        local trace = ply:GetEyeTrace()
        local ent = trace.Entity
        local doorTrace = ply:GetEyeTrace().Entity

        if IsValid(doorTrace) and doorTrace:IsDoor() and doorTrace:GetPos():Distance(ply:GetPos()) < 110 then
            halo.Add({doorTrace}, Color(255, 255, 255), 2, 2, 2, true, true)
        elseif IsValid(ent) and ent:GetClass() == "ix_item" and ent:GetPos():Distance(ply:GetPos()) < 95 then
            halo.Add({ent}, Color(255, 255, 255), 2, 2, 2, true, true)
        elseif IsValid(ent) and string.find(ent:GetClass(), "ix_loot_") and ent:GetPos():Distance(ply:GetPos()) < 95 then
            halo.Add({ent}, Color(255, 255, 255), 2, 2, 2, true, true)
        end
    end

    PLUGIN.cca_overlay2 = ix.util.GetMaterial'effects/advisor_fx_001'
    PLUGIN.cca_overlay = ix.util.GetMaterial'citizenlifestuff/cphudoverlay.png'
    PLUGIN.ota_overlay = ix.util.GetMaterial'citizenlifestuff/cphudoverlay.png'

    function PLUGIN:RenderScreenspaceEffects()
        local ply = LocalPlayer()
        local overlay_alpha = 1.0

        if GetGlobalBool("ixAJStatus") == true then
            DrawColorModify(colorModifyStorm)
        else
            DrawColorModify(colorModify)
        end

        local bloom = {
            passes = 4,
            darken = 0.4,
            multiply = 10,
            sizex = 15,
            sizey = 15,
            color = 1,
            colormul = 1,
            r = 255,
            g = 255,
            b = 255
        }

        DrawBloom(
            bloom.passes,
            bloom.darken,
            bloom.multiply,
            bloom.sizex,
            bloom.sizey,
            bloom.color,
            bloom.colormul,
            bloom.r,
            bloom.g,
            bloom.b
        )

        if ply:Team() == FACTION_VORTIGAUNT then DrawSobel(1) end
        if ply:IsCombine() and ix.option.Get("showCCAEffects", true) then
            render.UpdateScreenEffectTexture()
            local material = ply:Team() == FACTION_CCA and self.cca_overlay or self.ota_overlay
            material:SetFloat("$alpha", overlay_alpha)
            material:SetInt("$ignorez", 1)
            render.SetMaterial(material)
            render.DrawScreenQuad()

            if ply:Team() == FACTION_CCA then
                DrawSharpen(1.7, 1.7)
                local oldCamColor = {
                    ["$pp_colour_addr"] = 0,
                    ["$pp_colour_addg"] = 0,
                    ["$pp_colour_addb"] = 0,
                    ["$pp_colour_brightness"] = 0,
                    ["$pp_colour_contrast"] = 1,
                    ["$pp_colour_colour"] = 1,
                    ["$pp_colour_mulr"] = 0,
                    ["$pp_colour_mulg"] = 0,
                    ["$pp_colour_mulb"] = 0
                }
                DrawColorModify(oldCamColor)
            end
        end
    end

    function PLUGIN:Think()
        if IsValid(ix.gui.menu) or IsValid(ix.gui.characterMenu) then return end
        local ply = LocalPlayer()
        local char = ply:GetCharacter()
    end

    local function DrawCombineHud()
        local ply = LocalPlayer()
        local quota = ply:GetData("quota")
        local font = "CLCHud1"
        local color = Color(255, 255, 255)
        surface.SetFont(font)
        local startX = 10
        local startY = 31

        if quota then
            draw.SimpleTextOutlined("BEATING QUOTA: " .. quota .. " ::>", font, startX, startY, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
        end

        local showLocalAssets = ix.option.Get("showLocalAssets", true)
        local y = startY + 20

        if showLocalAssets then
            local squad = ply:GetSquad() or "NONE"
            draw.SimpleTextOutlined("PATROL TEAM: " .. squad .. " ::>", font, startX, y, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
            y = y + 20

            for _, v in pairs(player.GetAll()) do
                if v:Team() == FACTION_CCA and v:GetNetVar("squad") and ply:Team() == FACTION_CCA then
                    local unitText = "UNIT: " .. string.upper(v:Nick())
                    draw.SimpleTextOutlined(unitText, font, startX, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
                    y = y + 16
                elseif v:Team() == FACTION_OTA and ply:Team() == FACTION_OTA then
                    local unitText = "UNIT: " .. string.upper(v:Nick())
                    draw.SimpleTextOutlined(unitText, font, startX, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
                    y = y + 16
                end
            end
        end
    end

    function PLUGIN:CanDrawAmmoHUD(weapon)
        local ply = LocalPlayer()
        if combatWeapons[weapon:GetClass()] and ply:IsCombine() then return false end
    end

    local function DrawEffects(ply, char)
        surface.SetDrawColor(Color(255, 0, 0, 0))
        if ply:Health() <= 80 then
            surface.SetDrawColor(Color(255, 0, 0, 10))
        elseif ply:Health() <= 60 then
            surface.SetDrawColor(Color(255, 0, 0, 20))
        elseif ply:Health() <= 40 then
            surface.SetDrawColor(Color(255, 0, 0, 40))
        elseif ply:Health() <= 20 then
            surface.SetDrawColor(Color(255, 0, 0, 60))
        end

        surface.SetMaterial(Material("citizenlifestuff/bloodoverlay.png"))
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    end

    function PLUGIN:HUDPaint()
        local ply = LocalPlayer()
        local char = ply:GetCharacter()

        if ply:IsValid() and ply:Alive() and char then
            if (ix.hudEnabled == false) or (ix.CinematicIntro and ply:Alive()) or ply.ixIntroBool or (IsValid(ix.gui.menu) or IsValid(ix.gui.characterMenu)) or (hook.Run("ShouldDrawHUDBox") == false) then
                if IsValid(PlayerIcon) then PlayerIcon:Remove() end
                return false
            end

            DrawEffects(ply, char)
            if ply:IsCombine() and not (ply.adminHud == true) then DrawCombineHud(ply, char) end
        else
            if IsValid(PlayerIcon) then PlayerIcon:Remove() end
        end
    end

    function PLUGIN:HUDPaintBackground()
        local ply = LocalPlayer()
        local char = ply:GetCharacter()
        local ft = FrameTime()

        if ix.CinematicIntro and ply:Alive() then
            local letterBoxHeight = ScrH() / 8

            if letterBoxHoldTime and letterBoxHoldTime + ix.CinematicholdTime + 4 < CurTime() then
                letterBoxFade = Lerp(ft, letterBoxFade, 0)
                letterBoxTitleFade = Lerp(ft * 4, letterBoxTitleFade, 0)
                if letterBoxFade <= 0.01 then ix.CinematicIntro = false end
            elseif letterBoxHoldTime and letterBoxHoldTime + ix.CinematicholdTime < CurTime() then
                letterBoxTitleFade = Lerp(ft * 4, letterBoxTitleFade, 0)
            else
                letterBoxFade = Lerp(ft, letterBoxFade, 1)
                if letterBoxFade >= 0.9 then
                    letterBoxTitleFade = Lerp(ft, letterBoxTitleFade, 1)
                    letterBoxHoldTime = letterBoxHoldTime or CurTime()
                end
            end

            surface.SetDrawColor(color_black)
            surface.DrawRect(0, 0, ScrW(), letterBoxHeight * letterBoxFade)
            surface.DrawRect(0, (ScrH() - (letterBoxHeight * letterBoxFade)) + 1, ScrW(), letterBoxHeight)
            draw.DrawText(ix.CinematicTitle, "ixTitleFont", 20, ScrH() - ScreenScale(20) * 2, ColorAlpha(color_white, 255 * letterBoxTitleFade))
        else
            letterBoxTitleFade = 0
            letterBoxHoldTime = nil
        end
    end

    local angleLerp = Angle(0, 0, 0)
    local bobTime = 0
    local bobFactor = 0
    local swayTime = 0
    local swayLerp = Angle(0, 0, 0)

    local function CalcRoll(angles, velocity, rollAngle, rollSpeed)
        if angles == nil or velocity == nil then return 0 end
        local right = angles:Right()
        local side = velocity:Dot(right)
        local sign = side < 0 and -1 or 1
        side = math.abs(side)
        local value = rollAngle
        if side < rollSpeed then
            side = side * value / rollSpeed
        else
            side = value
        end
        return side * sign
    end

    local cl_rollangle = CreateClientConVar("cl_rollangle", '5.5', true, true):GetFloat()
    cvars.AddChangeCallback("cl_rollangle", function(convar, oldValue, newValue)
        cl_rollangle = tonumber(newValue) or cl_rollangle
    end)

    local cl_rollspeed = CreateClientConVar("cl_rollspeed", '200', true, true):GetFloat()
    cvars.AddChangeCallback("cl_rollspeed", function(convar, oldValue, newValue)
        cl_rollspeed = tonumber(newValue) or cl_rollspeed
    end)

    function PLUGIN:CalcView(ply, pos, ang, fov, nearZ, farZ)
        if IsValid(ix.gui.characterMenu) and not ix.gui.characterMenu:IsClosing() then return end
        if ply.ixRagdoll or ply.ixIntroState then return end
        if ix.option.Get("thirdpersonEnabled") then return end
        if ply:InVehicle() then return end
        if ply:GetLocalVar("bIsHoldingObject") then return end

        local view = {
            origin = pos,
            angles = ang,
            fov = fov - 5,
        }

        local roll = CalcRoll(ang, ply:GetVelocity(), cl_rollangle, cl_rollspeed)
        view.angles.roll = view.angles.roll + roll

        local velocity = ply:GetVelocity():Length2D()
        local runningSpeed = ply:GetRunSpeed()
        local walkingSpeed = ply:GetWalkSpeed()
        local speedFraction = math.Clamp((velocity - walkingSpeed) / (runningSpeed - walkingSpeed), 0, 1)
        local shouldBob = ply:Alive() and velocity > 0 and ply:IsOnGround()

        if shouldBob then
            local frequencyMultiplier = Lerp(speedFraction, 5, 15)
            local amplitudeMultiplier = Lerp(speedFraction, 0.1, 0.1)
            bobTime = bobTime + FrameTime() * frequencyMultiplier
            bobFactor = math.sin(bobTime) * amplitudeMultiplier
            view.origin = view.origin + Vector(0, 0, bobFactor)
            local angleBobPitch = bobFactor * Lerp(speedFraction, 3, 5)
            view.angles.pitch = view.angles.pitch + angleBobPitch
        else
            bobFactor = math.max(bobFactor - FrameTime() * 0.05, 0)
        end

        if shouldBob then
            local movementDirection = ply:GetVelocity():GetNormalized()
            local swayAmount = Lerp(speedFraction, 0.5, 1.5)
            swayLerp = LerpAngle(FrameTime() * 5, swayLerp, Angle(movementDirection.y * swayAmount, -movementDirection.x * swayAmount, 0))
            view.angles = view.angles + swayLerp
        end

        local isWeaponRaised = IsValid(ply) and ply:Alive() and ply:IsWepRaised()
        if isWeaponRaised and not (ply:GetMoveType() == MOVETYPE_NOCLIP or ply.ixRagdoll) then
            angleLerp = LerpAngle(0.25, angleLerp, ang)
        else
            angleLerp = ang
        end

        view.angles = angleLerp

        return view
    end
end