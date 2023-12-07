local PLUGIN = PLUGIN

if CLIENT then
    local nextHint = 0
    local bInHint = false
    local surface = surface
    local text01position = 50
    local text02position = 30
    local nextMessage = 0
    local lastMessage = ""

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

    local colorModify = {
        ["$pp_colour_addr"] = 0,
        ["$pp_colour_addg"] = 0,
        ["$pp_colour_addb"] = 0,
        ["$pp_colour_brightness"] = 0.03,
        ["$pp_colour_contrast"] = 1,
        ["$pp_colour_colour"] = 1.1,
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 0,
        ["$pp_colour_mulb"] = 0
    }

    local colorModifyStorm = {
        ["$pp_colour_addr"] = 0,
        ["$pp_colour_addg"] = 0.1,
        ["$pp_colour_addb"] = 0.2,
        ["$pp_colour_brightness"] = -0.03,
        ["$pp_colour_contrast"] = 1,
        ["$pp_colour_colour"] = 0.7,
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 0.7,
        ["$pp_colour_mulb"] = 0.8
    }

    ix.config.Add("enableHaloEffects", true, "Whether to enable halo effects for doors and items.", nil, {
        category = "Halo Effects"
    })

    ix.option.Add("enableHaloEffects", ix.type.bool, true, {
        category = "Halo Effects"
    })

    function PLUGIN:PreDrawHalos()
        if not ix.config.Get("enableHaloEffects", true) then return end -- Halo effects are disabled
        if not ix.option.Get("enableHaloEffects", true) then return end -- Halo effects are disabled
        local ply = LocalPlayer()
        local trace = ply:GetEyeTrace()
        local ent = trace.Entity
        local doorTrace = ply:GetEyeTrace().Entity

        if IsValid(doorTrace) and doorTrace:IsDoor() and doorTrace:GetPos():Distance(ply:GetPos()) < 110 then
            halo.Add({doorTrace}, Color(255, 255, 255), 2, 2, 2, true, true)
        elseif IsValid(ent) and ent:GetClass() == "ix_item" and ent:GetPos():Distance(ply:GetPos()) < 95 then
            halo.Add({ent}, Color(255, 255, 255), 2, 2, 2, true, true)
        end
    end

    function PLUGIN:RenderScreenspaceEffects()
        local ply = LocalPlayer()

        if not (GetGlobalBool("ixAJStatus") == true) then
            if ix.option.Get("hudScreenEffect", true) then
                DrawColorModify(colorModify)
            end
        else
            DrawColorModify(colorModifyStorm)
        end

        if ply:Team() == FACTION_VORTIGAUNT then
            DrawSobel(1)
        end
    end

    ix.gui.CombineHudMessagesList = {"Updating biosignal co-ordinates...", "Parsing heads-up display and data arrays...", "Working deconfliction with other ground assets...", "Transmitting physical transition vector...", "Sensoring proximity...", "Regaining equalization modules...", "Encoding network messages...", "Analyzing Overwatch protocols...", "Filtering incoming messages...", "Updating biosignal coordinates...", "Synchronizing database records...", "Appending all data to black box...",}

    ix.gui.CombineHudMessages = ix.gui.CombineHudMessages or {}
    ix.gui.CombineHudMessageID = ix.gui.CombineHudMessageID or 0

    function ix.gui.AddCombineDisplayMessage(text, col, sound, soundfile, font)
        local ply = LocalPlayer()
        ix.gui.CombineHudMessageID = ix.gui.CombineHudMessageID + 1
        text = "<:: " .. string.upper(text)

        local data = {
            message = "",
            bgCol = col,
            messagefont = font or "CLCHud1"
        }

        table.insert(ix.gui.CombineHudMessages, data)

        if #ix.gui.CombineHudMessages > math.random(4, 8) then
            table.remove(ix.gui.CombineHudMessages, 1)
        end

        local i = 1
        local id = "ix.gui.CombineHudMessages.ID." .. ix.gui.CombineHudMessageID

        timer.Create(id, 0.01, #text + 1, function()
            data.message = string.sub(text, 1, i + 2)
            i = i + 3

            if data.message == #text then
                timer.Remove(id)
            end
        end)

        if sound then
            ply:EmitSound(soundfile or "npc/roller/code2.wav")
        end
    end

    function PLUGIN:Think()
        if IsValid(ix.gui.menu) or IsValid(ix.gui.characterMenu) then return end
        local ply = LocalPlayer()
        local char = ply:GetCharacter()

        if (nextMessage or 0) < CurTime() then
            local message = ix.gui.CombineHudMessagesList[math.random(1, #ix.gui.CombineHudMessagesList)]

            if message ~= (lastMessage or "") then
                ix.gui.AddCombineDisplayMessage(message, nil, false)
                lastMessage = message
            end

            nextMessage = CurTime() + math.random(4, 20)
        end
    end

    local function DrawCombineHud()
        local ply = LocalPlayer()
        local pos = ply:GetPos()
        local grid = math.Round(pos.x / 100) .. " / " .. math.Round(pos.y / 100)
        local zone = ply:GetPlayerInArea() or "<UNDOCUMENTED ZONE>"
        local quota = ply:GetData("quota")
        local font = "CLCHud1"
        surface.SetFont(font)

        for i, msgData in pairs(ix.gui.CombineHudMessages) do
            msgData.y = msgData.y or 0
            local w, h = surface.GetTextSize(msgData.message)
            local x, y = 10, ((i - 1) * h) + 5
            msgData.y = Lerp(0.07, msgData.y, y)
            draw.SimpleTextOutlined(msgData.message, font, x, msgData.y, msgData.bgCol or color_white, nil, nil, 1, color_black)
        end

        -- City Codes
        draw.SimpleTextOutlined([[<:: // LOCAL INFORMATION ASSET \\ ::>]], font, ScrW() / 2, 5, Color(0, 138, 216), TEXT_ALIGN_CENTER, nil, 1, color_black)
        local value = ix.config.Get("cityCode", 0)
        local cityCodes = ix.cityCodes[value]

        if cityCodes then
            draw.SimpleTextOutlined("<:: CIVIC POLITISTABILIZATION INDEX: " .. cityCodes[1] .. " ::>", font, ScrW() / 2, 5 + 16, cityCodes[2] or color_white, TEXT_ALIGN_CENTER, nil, 1, color_black)
        end

        -- Top Right
        draw.SimpleTextOutlined("// LOCAL ASSET ::>", font, ScrW() - 10, 5, Color(0, 138, 216), TEXT_ALIGN_RIGHT, nil, 1, color_black)
        draw.SimpleTextOutlined("VITALS: " .. ply:Health() .. "% ::>", font, ScrW() - 10, 42, color_white, TEXT_ALIGN_RIGHT, nil, 1, color_black)
        draw.SimpleTextOutlined("SPS CHARGE: " .. ply:Armor() .. "% ::>", font, ScrW() - 10, 58, color_white, TEXT_ALIGN_RIGHT, nil, 1, color_black)
        draw.SimpleTextOutlined("BIOSIGNAL GRID: " .. grid .. " ::>", font, ScrW() - 10, 74, color_white, TEXT_ALIGN_RIGHT, nil, 1, color_black)
        draw.SimpleTextOutlined("BIOSIGNAL ZONE: " .. zone .. " ::>", font, ScrW() - 10, 90, color_white, TEXT_ALIGN_RIGHT, nil, 1, color_black)

        if quota then
            draw.SimpleTextOutlined("BEATING QUOTA: " .. quota .. " ::>", font, ScrW() - 10, 109, color_white, TEXT_ALIGN_RIGHT, nil, 1, color_black)
        end

        local y = 16
        local showLocalAssets = ix.option.Get("showLocalAssets", true)

        if showLocalAssets then
            local squad = ply:GetSquad() or "NONE"
            draw.SimpleTextOutlined("<:: PATROL TEAM: " .. squad .. " //", font, 10, 200, Color(0, 138, 216), nil, nil, 1, color_black)

            for _, v in pairs(player.GetAll()) do
                if v:Team() == FACTION_CCA and v:GetNetVar("squad") and ply:Team() == FACTION_CCA then
                    local unitText = "<:: UNIT: " .. string.upper(v:Nick())
                    draw.SimpleTextOutlined(unitText, font, 10, 210 + y, color_white, nil, nil, 1, color_black)
                    y = y + 16
                elseif v:Team() == FACTION_OTA and ply:Team() == FACTION_OTA then
                    local unitText = "<:: UNIT: " .. string.upper(v:Nick())
                    draw.SimpleTextOutlined(unitText, font, 10, 210 + y, color_white, nil, nil, 1, color_black)
                    y = y + 16
                end
            end
        end

        local activeWeapon = ply:GetActiveWeapon()

        if IsValid(activeWeapon) and combatWeapons[activeWeapon:GetClass()] then
            local weaponName = activeWeapon:GetPrintName()
            local weaponAmmo1 = activeWeapon:Clip1()
            local weaponAmmo2 = ply:GetAmmoCount(activeWeapon:GetPrimaryAmmoType())
            local weaponAmmo3 = ply:GetAmmoCount(activeWeapon:GetSecondaryAmmoType())
            local weaponprimarycolor = color_white
            weaponAmmo1 = weaponAmmo1 > 0 and weaponAmmo1 or "N/A"
            weaponAmmo2 = weaponAmmo2 > 0 and weaponAmmo2 or "N/A"
            weaponAmmo3 = weaponAmmo3 > 0 and weaponAmmo3 or "N/A"

            if combatWeapons[activeWeapon:GetClass()] then
                weaponName = combatWeapons[activeWeapon:GetClass()]
            end

            if activeWeapon:Clip1() < activeWeapon:GetMaxClip1() / 4 then
                weaponprimarycolor = Color(255, 0, 0)

                if (ply.nextAmmoWarn or 0) < CurTime() then
                    ix.gui.AddCombineDisplayMessage("LOW ON AMMO.. RELOAD.", weaponprimarycolor, true)
                    ply.nextAmmoWarn = CurTime() + 20
                end
            end

            draw.SimpleTextOutlined("<:: LOCAL WEAPONRY //", font, ScrW() - 195, 133, Color(0, 138, 216), nil, nil, 1, color_black)
            draw.SimpleTextOutlined("<:: FIREARM: " .. string.upper(weaponName), font, ScrW() - 195, 155, color_white, nil, nil, 1, color_black)
            draw.SimpleTextOutlined("<:: AM: [ " .. weaponAmmo1 .. " ] / [ " .. weaponAmmo2 .. " ]", font, ScrW() - 195, 177, weaponprimarycolor, nil, nil, 1, color_black)
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

        surface.SetMaterial(Material("willardnetworks/nlrbleedout/bleedout-background.png"))
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    end

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

            DrawEffects(ply, char)

            if ply:IsCombine() and not (ply.adminHud == true) then
                DrawCombineHud(ply, char)
            end
        else
            if IsValid(PlayerIcon) then
                PlayerIcon:Remove()
            end
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

                if letterBoxFade <= 0.01 then
                    ix.CinematicIntro = false
                end
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
end
