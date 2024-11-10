include("shared.lua")
local imgui = include("imgui.lua")
local currentScreen = "main"
local loadingTargetScreen = nil
local loadingStartTime = 0
local loadingDuration = 0
local spinAngle = 0
local lastPeriodUpdateTime = 0
local periodCount = 0

-- New variables for rank navigation with images
local ranks = {
    {
        image = Material("citizenlifestuff/combine/apclogocitizenlife.png"),
        info = "{BASIC-UNIT}\nThe first rank in the \nCombine Civil Authority,\n these units have  \n the most basic; and\n important equipment.",
        id = 1,  -- Reference to ix.ranks.cca[1]
        imgWidth = 185, -- Larger size for Basic Unit
        imgHeight = 185
    },
    {
        image = Material("citizenlifestuff/combine/disabledperson.png"),
        info = "{GROUND-UNIT}\nUnits armed with\n rapid firing sub machine \n guns, these units serve fit \n to respond to any situation\n deemed too dangerious\n for standard units.",
        id = 2,  -- Reference to ix.ranks.cca[2]
        imgWidth = 128, -- Standard size for others
        imgHeight = 128
    },
    {
        image = Material("citizenlifestuff/combine/OTAlogo.png"),
        info = "{RANK-LEADER}\nRank leaders\n armed with viscerators\n oversee Patrol Teams,\n ensuring law enforcement\n and the combating of \nanti-civil activity.",
        id = 3,  -- Reference to ix.ranks.cca[4]
        imgWidth = 128,
        imgHeight = 128
    }
}

local errorMessage = {
    text = "",
    displayUntil = 0,
    visible = false
}

-- Function to set and display an error message
function SetErrorMessage(msg)
    errorMessage.text = msg
    errorMessage.displayUntil = CurTime() + 3 -- Display for 3 seconds
    errorMessage.visible = true
    surface.PlaySound("buttons/combine_button2.wav")
end

-- Display the error message
local function DisplayErrorMessage()
    if errorMessage.visible and CurTime() < errorMessage.displayUntil then
        local posX, posY = -93, -85
        local width, height = 200, 50
        surface.SetDrawColor(255, 0, 0, 155) -- Red background
        surface.DrawRect(posX, posY, width, height)
        draw.SimpleText(errorMessage.text, "ErrorTerm", posX + width / 2, posY + height / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    elseif errorMessage.visible then
        errorMessage.visible = false -- Hide the message after 3 seconds
    end
end

-- Listen for the error message from the server
net.Receive("DisplayError", function()
    local errorMsg = net.ReadString()
    SetErrorMessage(errorMsg) -- Set the error message
end)

local currentRankIndex = 1

function ENT:Draw()
    self:DrawModel()
    if imgui.Entity3D2D(self, Vector(16.3, 0, 0), Angle(0, 90, 90), 0.1) then
        surface.SetDrawColor(Color(0, 94, 201))
        surface.DrawRect(-137, -275, 284, 555) -- Drawing a background for our screen

        -- Define colors
        local navyBlue = Color(5, 42, 56)
        local lightCyan = Color(4, 116, 152)

        -- Loading Screen
        if currentScreen == "loading" then
            local mat = Material("citizenlifestuff/combine/citadelcorelogo.png")
            spinAngle = (spinAngle + 2) % 360 -- Increase the angle for spinning effect
            surface.SetMaterial(mat)
            surface.SetDrawColor(Color(155, 155, 155))
            surface.DrawTexturedRectRotated(0, 0, 128, 128, spinAngle) -- Adjust size and position as needed
            if CurTime() >= lastPeriodUpdateTime + 1 then
                periodCount = (periodCount + 1) % (3 + 1)
                lastPeriodUpdateTime = CurTime()
            end

            local loadingText = "CCA.TERM=LOADING" .. string.rep(".", periodCount)
            draw.SimpleText(loadingText, "RadioFont", 0, 100, Color(155, 155, 155), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            if CurTime() >= (loadingStartTime + loadingDuration) then
                currentScreen = loadingTargetScreen
            end
        elseif currentScreen == "main" then
            -- MAIN
            draw.SimpleText("Equipment Vendor", "RadioFont", 0, -250, Color(155, 155, 155), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            local mat = Material("citizenlifestuff/combine/combinelogo2.png")
            surface.SetMaterial(mat)
            surface.SetDrawColor(Color(225, 225, 255))
            surface.DrawTexturedRect(-93, 0, 200, 200)
            
            -- Rank button with background
            local isHoveringRank = imgui.IsHovering(-100, -200, 200, 50)
            surface.SetDrawColor(isHoveringRank and lightCyan or navyBlue)
            surface.DrawRect(-93, -200, 200, 50)
            if imgui.xTextButton("RANK", "RadioFont", -93, -200, 200, 50, 2, Color(13, 151, 177), Color(55, 195, 192)) then 
                StartLoadingScreen("rank") 
                surface.PlaySound("buttons/combine_button1.wav")
            end
            
            -- Equipment button with background
            local isHoveringEquipment = imgui.IsHovering(-100, -100, 200, 50)
            surface.SetDrawColor(isHoveringEquipment and lightCyan or navyBlue)
            surface.DrawRect(-93, -100, 200, 50)
            if imgui.xTextButton("EQUIPMENT", "RadioFont", -93, -100, 200, 50, 2, Color(13, 151, 177), Color(55, 195, 192)) then 
                StartLoadingScreen("equipment")
                surface.PlaySound("buttons/combine_button1.wav")
            end
        elseif currentScreen == "rank" then
            -- RANK
            if imgui.xTextButton("BACK", "RadioFont", -93, -275, 200, 50, 5, Color(155, 155, 155), Color(13, 151, 177)) then 
                StartLoadingScreen("main") 
                surface.PlaySound("buttons/combine_button1.wav")
            end

            surface.SetDrawColor(Color(4, 45, 91, 245))
            surface.DrawRect(-137, 30, 284, 175)
            
            -- Rank navigation arrows
            if imgui.xTextButton("<", "RadioFont", -130, -50, 50, 50, 2, Color(155, 155, 155), navyBlue) then
                currentRankIndex = currentRankIndex - 1
                surface.PlaySound("buttons/combine_button7.wav")
                if currentRankIndex < 1 then currentRankIndex = #ranks end
            end

            if imgui.xTextButton(">", "RadioFont", 80, -50, 50, 50, 2, Color(155, 155, 155), navyBlue) then
                currentRankIndex = currentRankIndex + 1
                surface.PlaySound("buttons/combine_button7.wav")
                if currentRankIndex > #ranks then currentRankIndex = 1 end
            end

            -- Display current rank image
            local currentRank = ranks[currentRankIndex]
            surface.SetMaterial(currentRank.image)
            surface.SetDrawColor(155, 155, 155, 255)
            -- Use the specified image dimensions from the ranks table
            local imageWidth = currentRank.imgWidth
            local imageHeight = currentRank.imgHeight
            -- Calculate position to center the image
            local imageX = -imageWidth / 2
            local imageY = -50 - imageHeight / 2
            surface.DrawTexturedRect(imageX, imageY, imageWidth, imageHeight)
            
            -- Display rank info
            local infoText = currentRank.info
            local infoTextYPosition = 50 -- Adjust this value to move the text down
            local selectButtonYPosition = infoTextYPosition + 165 -- Positioning the button below the rank info
            if imgui.xTextButton("SELECT", "RadioFont", -93, selectButtonYPosition, 200, 50, 2, Color(155, 155, 155), Color(13, 151, 177), lightCyan) then
                net.Start("SelectRank")
                net.WriteInt(currentRank.id, 32)  -- Send the rank ID to the server
                net.SendToServer() 
            end

            -- Splitting the infoText into lines
            for line in string.gmatch(infoText, "[^\n]+") do
                draw.SimpleText(line, "RadioFont", 0, infoTextYPosition, Color(155, 155, 155), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                infoTextYPosition = infoTextYPosition + 20 -- Adjust line spacing
            end

            DisplayErrorMessage()
        elseif currentScreen == "equipment" then
            -- EQUIPMENT
            if imgui.xTextButton("Stunstick", "RadioFont", -93, -200, 200, 50, 2, Color(13, 151, 177), Color(55, 195, 192)) then
                net.Start("SelectWeapon")
                net.WriteString("stunstick")
                net.SendToServer()
            end
            
            if imgui.xTextButton("USP", "RadioFont", -93, -100, 200, 50, 2, Color(13, 151, 177), Color(55, 195, 192)) then
                net.Start("SelectWeapon")
                net.WriteString("usp")
                net.SendToServer()
            end

            if imgui.xTextButton("MP7", "RadioFont", -93, 0, 200, 50, 2, Color(13, 151, 177), Color(55, 195, 192)) then
                net.Start("SelectWeapon")
                net.WriteString("smg")
                net.SendToServer()
            end

            if imgui.xTextButton("Viscerator", "RadioFont", -93, 100, 200, 50, 2, Color(13, 151, 177), Color(55, 195, 192)) then
                net.Start("SelectWeapon")
                net.WriteString("manhack")
                net.SendToServer()
            end

            DisplayErrorMessage()

            if imgui.xTextButton("BACK", "RadioFont", -93, -275, 200, 50, 5, Color(155, 155, 155), Color(13, 151, 177)) then 
                StartLoadingScreen("main") 
                surface.PlaySound("buttons/combine_button1.wav")
            end
        end

        local scanlinesMat = Material("citizenlifestuff/scanlines.png")
        surface.SetMaterial(scanlinesMat)
        surface.SetDrawColor(0, 94, 201)
        surface.DrawTexturedRect(-137, -275, 284, 555)

        imgui.End3D2D()
    end
end

function StartLoadingScreen(targetScreen)
    currentScreen = "loading"
    loadingTargetScreen = targetScreen
    loadingStartTime = CurTime()
    loadingDuration = math.random(1, 2) -- Random duration between 1 to 2 seconds
    periodCount = 0
    lastPeriodUpdateTime = CurTime()
end