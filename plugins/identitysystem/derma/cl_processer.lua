if CLIENT then
    net.Receive("ProcessorActionConfirmation", function()
        local confirmPanel = vgui.Create("DFrame")
        confirmPanel:SetSize(400, 200)
        confirmPanel:SetTitle("WARNING!")
        confirmPanel:SetVisible(true)
        confirmPanel:Center()
        confirmPanel:MakePopup()
        confirmPanel:ShowCloseButton(false)

        local label = vgui.Create("DLabel", confirmPanel)
        label:SetPos(50, 40)
        label:SetSize(300, 100)
        label:SetWrap(true) -- Enable text wrapping
        label:SetContentAlignment(7)
        label:SetText("WARNING: If you proceed, your character will be removed and you will be whitelisted for Civil Protection.\n\nDo you want to proceed?")

        local yesButton = vgui.Create("DButton", confirmPanel)
        yesButton:SetPos(50, 150)
        yesButton:SetSize(90, 25)
        yesButton:SetText("Yes")
        yesButton.DoClick = function()
            confirmPanel:Remove()
            net.Start("ProcessorActionConfirmation")
            net.WriteBool(true) -- Player confirmed the action
            net.SendToServer()

            -- Create a black panel that covers the entire screen
            local blackoutPanel = vgui.Create("DPanel")
            blackoutPanel:SetSize(ScrW(), ScrH())
            blackoutPanel:SetBackgroundColor(Color(0, 0, 0))

            -- Set the alpha to 0 to start with
            blackoutPanel:SetAlpha(0)

            -- Perform fade-in effect
            local fadeTime = 2 -- Fade duration in seconds
            local fadeInAlpha = 255

            timer.Simple(fadeTime, function()
                -- Fade complete, add text
                local textPanel = vgui.Create("DLabel", blackoutPanel)
                textPanel:SetPos(blackoutPanel:GetWide() / 2 - 150, blackoutPanel:GetTall() / 2 - 50)
                textPanel:SetSize(300, 100)
                textPanel:SetWrap(true)
                textPanel:SetContentAlignment(5) -- Center-align text
                textPanel:SetAlpha(0)
                textPanel:SetText("") -- Set initial text as an empty string
                textPanel:SetFont("CLCHud1")

                local fullText = "ASSESSMENT: PROTECT, SERVE.\n\nSUBJECT: "..LocalPlayer():Name().."."

                local textPos = 0 -- Track the position of the text
                local nextTime = CurTime()

                timer.Create("TypewriterEffect", 0.35, string.len(fullText), function()
                    textPos = textPos + 1
                    nextTime = CurTime() + 0.35
                    textPanel:SetText(string.sub(fullText, 1, textPos))
                    surface.PlaySound("ambient/machines/keyboard" .. tostring(math.random(1, 6)) .. "_clicks.wav")
                end)

                -- Wait for 20 seconds
                timer.Simple(20, function()
                    -- Perform fade-out effect
                    local fadeOutTime = 2 -- Fade duration in seconds
                    local fadeOutAlpha = 0

                    textPanel:AlphaTo(fadeOutAlpha, fadeOutTime, 0, function()
                        textPanel:Remove()
                        blackoutPanel:AlphaTo(fadeOutAlpha, fadeOutTime, 0, function()
                            blackoutPanel:Remove()
                        end)
                    end)
                end)

                textPanel:AlphaTo(255, fadeTime, 0)
            end)

            blackoutPanel:AlphaTo(fadeInAlpha, fadeTime, 0)
        end


        local noButton = vgui.Create("DButton", confirmPanel)
        noButton:SetPos(250, 150)
        noButton:SetSize(90, 25)
        noButton:SetText("No")
        noButton.DoClick = function()
            confirmPanel:Remove()
            net.Start("ProcessorActionConfirmation")
            net.WriteBool(false) -- Player canceled the action
            net.SendToServer()
        end
    end)
end
