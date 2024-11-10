include("shared.lua")
function ENT:Draw()
    self:DrawModel()
    local pos = self:GetPos()
    local ang = self:GetAngles()
    pos = pos + (ang:Up() * 48)
    pos = pos + (ang:Forward() * -2.36)
    pos = pos + (ang:Right() * 9.8)
    ang:RotateAroundAxis(self:GetAngles():Up(), 90)
    ang:RotateAroundAxis(self:GetAngles():Right(), -42)
    cam.Start3D2D(pos, ang, 0.07)
    surface.SetDrawColor(Color(30, 30, 30))
    surface.DrawRect(0, 0, 225, 115)
    surface.SetDrawColor(ix.config.Get("color"))
    surface.DrawOutlinedRect(0, 0, 225, 115, 5)
    draw.DrawText("TERMINAL: " .. self:EntIndex(), "RadioFont", 8, 4, Color(65, 105, 200), TEXT_ALIGN_LEFT)
    draw.DrawText("CITY INDEX: 17", "RadioFont", 8, 32, Color(65, 105, 200), TEXT_ALIGN_LEFT)
    draw.DrawText("PLEASE CONFIRM IDENTITY", "ixSmallFont", 8, 90, color_white, TEXT_ALIGN_LEFT)
    cam.End3D2D()
end

local combineLogoMat = Material("citizenlifestuff/combine/apclogocitizenlife.png") 

-- funny
local PANEL = {}

local function CursorStop(pan)
    pan:SetCursor("blank")

    for i, v in pairs(pan:GetChildren()) do
        CursorStop(v)
    end
end

function PANEL:Init()
    local w, h = ScrW() / 1.3, ScrH() / 1.3
    self:SetSize(w, h)
    self:Center()
    self:SetVisible(true)
    self:MakePopup()

    --- Charges panel start

    self.scrollPanel = self:Add("DScrollPanel")
    self.scrollPanel:SetSize(w / 1.9, h / 0.05)
    self.scrollPanel:SetPos(0, h / 10.8)
    self.setting = {}


    
    for k, v in SortedPairs(ix.combineterminal.charges) do
        local chargeButton = self.scrollPanel:Add("DButton")
        chargeButton:SetText(v.name)
        chargeButton:SetFont("RadioFont")
        chargeButton:Dock(TOP)
        chargeButton:DockMargin(4, 4, 4, 0)
        chargeButton.DoClick = function(selfButton)
            -- Toggle the state of the charge
            if self.setting[k] then
                self.setting[k] = nil
                selfButton:SetColor(nil)  -- Reset to default color
            else
                self.setting[k] = { button = selfButton, selected = true }
                selfButton:SetColor(Color(255, 0, 0))  -- Set to green when selected
            end
    
            -- Update the sentence button text
            self:UpdateSentenceButton()
        end
    end
    
    self.dockPanel = vgui.Create("Panel", self)
    self.dockPanel:SetSize(w / 2.08)
    self.dockPanel:DockMargin(5, 5, 5, 5)
    self.dockPanel:Dock(RIGHT)
    

-- Assuming 'dock' is a valid panel created elsewhere in your code.
local dock = self.dockPanel




-- yes sirrrr
self.dockPanel = vgui.Create("Panel", self)
    self.dockPanel:SetSize(w / 3.0)
    self.dockPanel:DockMargin(5, 5, -700, 500)
    self.dockPanel:Dock(RIGHT)

    function self.dockPanel:Paint(w, h)
        surface.SetDrawColor(35, 35, 35, 0)
        surface.DrawRect(0, 0, w, h)
    end

    local dock = self.dockPanel
    local ent = LocalPlayer()
    dock.modelPanel = vgui.Create("DModelPanel", dock)
    dock.modelPanel:SetSize(w / 3.2, h / 3)
    dock.modelPanel:SetPos(w / 90, 50)

    local cam = dock.modelPanel:GetCamPos()
    cam:Rotate(Angle(0, -35, 0))

    dock.modelPanel:SetModel(ent:GetModel())
    dock.modelPanel:SetLookAt(dock.modelPanel.Entity:GetBonePosition(dock.modelPanel.Entity:LookupBone("ValveBiped.Bip01_Head1")))
    dock.modelPanel:SetFOV(30)
    function dock.modelPanel:LayoutEntity()
        return
    end
    
    local oldDraw = dock.modelPanel.Paint
    
    function dock.modelPanel:Paint(w, h)
        surface.SetDrawColor(25, 25, 25)
        surface.DrawRect(0, 0, w, h)
    
        if self.Entity then
            oldDraw(self, w, h)
        end
    
        surface.SetDrawColor(1, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h, 2)
    end


------- Console messages

self.messagePanel = vgui.Create("DPanel", self)
    self.messagePanel:SetSize(w / 3.2, h / 1.8)  -- Adjust size as needed
    self.messagePanel:SetPos(w * 0.664, h * 0.4)  -- Position at bottom right
    function self.messagePanel:Paint(w, h)
        surface.SetDrawColor(10, 10, 10, 200)  -- Semi-transparent black background
        surface.DrawRect(0, 0, w, h)
    
        if self.randomMessages then
            local startY = 15  -- Starting Y position for the first message
            local gap = 40  -- Gap between messages
    
            for _, message in ipairs(self.randomMessages) do
                draw.SimpleText(message, "RadioFont", w / 2, startY, Color(0, 138, 216), TEXT_ALIGN_CENTER)
                startY = startY + gap  -- Move to the next line
            end
        else
            draw.SimpleText("Waiting for messages...", "RadioFont", w / 2, 15, Color(0, 138, 216), TEXT_ALIGN_CENTER)
        end
    end  

    -- Initialize the messages
    self.messages = {}

    -- Start a timer to update messages
    timer.Create("UpdateMessagesTimer", 5, 0, function()
        if IsValid(self) then
            self:UpdateMessages()
        end
    end)


-------- Console ends here    
self.sentencebutton = self:Add("ixMenuButton")
self.sentencebutton:Dock(BOTTOM)
self.sentencebutton:SizeToContents()
self.sentencebutton:SetText("arrest (Charges: 0 | Cycles: 0)")
self.sentencebutton:SetFont("RadioFont")
self.sentencebutton:SetTextColor(Color(255, 0, 0)) -- Red color initially

self.sentencebutton.DoClick = function()
    local chargecount = 0
    local charges = {}
    local chargestimeoriginal = 0
    local chargestime = 0
    for k, v in pairs(self.setting) do
        table.insert(charges, k)
        chargestimeoriginal = chargestimeoriginal + ix.combineterminal.charges[k].severity
        chargestime = math.min(ix.combineterminal.charges[k].severity * 40, 240)
        chargecount = chargecount + 1
    end

    if chargecount > 0 and chargecount < 5 then
        net.Start("ixCombineTerminalCharge")
        net.WriteTable(charges)
        net.WriteUInt(chargestimeoriginal, 4)
        net.WriteUInt(chargestime, 12)
        net.SendToServer()
    else
        if chargecount > 4 then
            LocalPlayer():Notify("You cannot select too many charges!")
        elseif chargecount == 0 then
            LocalPlayer():Notify("You must at least select one reasonable charge!")
        end
    end
end

    self.close = vgui.Create("DButton", self)
    self.close:SetFont("RadioFont")
    self.close:SetSize(16, 16)
    self.close:SetPos((w - h / 64) - 8, 5)
    self.close:SetText("X")
    -- Using a dot instead of colon so self isn't overriden
    function self.close.DoClick()
        surface.PlaySound("ui/buttonclick.wav")
        timer.Remove("UpdateMessagesTimer")
        self:Remove()
    end
	CursorStop(self)
end

function PANEL:UpdateMessages()
    local messages = ix.gui.CombineHudMessagesList or {}
    local messageCount = #messages

    self.messagePanel.randomMessages = {}  -- Initialize with an empty table

    if messageCount > 0 then
        for i = 1, 10 do  -- Number of messages to display simultaneously
            local randomIndex = math.random(1, messageCount)
            table.insert(self.messagePanel.randomMessages, messages[randomIndex])
        end
    end
end

function PANEL:UpdateSentenceButton()
    local chargeCount = 0
    local chargeTimeTotal = 0

    -- Iterate through the settings to count charges and calculate total time
    for k, _ in pairs(self.setting) do
        chargeCount = chargeCount + 1
        chargeTimeTotal = chargeTimeTotal + ix.combineterminal.charges[k].severity
    end

    -- Update the sentence button text
    local sentenceText = string.format("arrest (Charges: %d | Cycles: %d)", chargeCount, math.Clamp(chargeTimeTotal * 40, 0, 240))
    self.sentencebutton:SetText(sentenceText)

    -- Update the button color based on whether any charges are selected
    if chargeCount > 0 then
        self.sentencebutton:SetTextColor(Color(0, 255, 0)) -- Green if any charges are selected
    else
        self.sentencebutton:SetTextColor(Color(255, 0, 0)) -- Red if no charges are selected
    end
end

function PANEL:AddCharge(chargeid, data)
    local panel = self  -- Capture 'self' in a local variable
    local chargesetting = self.scrollPanel:Add("ixSettingsRowBool")
    chargesetting:SetText(data.name)
    chargesetting:SizeToContents()
    chargesetting:Dock(TOP)
    chargesetting:DockMargin(4, -10, 1, 1)
    chargesetting.chargeID = chargeid

    function chargesetting:OnValueChanged(value)
        if value then
            panel.setting[self.chargeID] = value  -- Use 'panel' instead of 'self'
        else
            panel.setting[self.chargeID] = nil
        end

        local chargecount = 0
        local timecount = 0
        for k, v in pairs(panel.setting) do  -- Use 'panel' instead of 'self'
            timecount = timecount + ix.combineterminal.charges[k].severity
            chargecount = chargecount + 1
        end

        panel.sentencebutton:SetText("arrest (Charges: " .. chargecount .. " | Cycles: " .. math.Clamp(timecount, 0, 5 * 60) .. ")")
    end
end

function PANEL:PaintCursor(mat)
    local x, y = self:LocalCursorPos()
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(mat)
    surface.DrawTexturedRect(x, y, 25, 25)
end

local cursMat = Material("vgui/cursors/arrow")
function PANEL:Paint(w, h)
    -- Background
    surface.SetDrawColor(40, 40, 40, 245)
    surface.DrawRect(0, 0, w, h)

    -- Draw the Combine logo
    surface.SetDrawColor(0, 0, 0, 128) -- Set color to black with 50% transparency
    surface.SetMaterial(combineLogoMat) -- Set the material to the Combine logo
    surface.DrawTexturedRect(-299, -250, 1300, 1300) -- Adjust the position and size as needed

        -- Draw the Combine logo
    surface.SetDrawColor(0, 0, 0, 128) -- Set color to black with 50% transparency
    surface.SetMaterial(Material("citizenlifestuff/scanlines.png")) -- Set the material to the Combine logo
    surface.DrawTexturedRect(0, 0, w, h) -- Adjust the position and size as needed
    

    -- Gray border
    local borderThickness = 5
    local borderColor = Color(128, 128, 128, 255)
    surface.SetDrawColor(borderColor)
    surface.DrawOutlinedRect(0, 0, w, h, borderThickness)

    -- Other UI elements (e.g., title, text)
    -- Example:
    draw.SimpleText("Sentence Terminal", "RadioFont", w / 14, 20, color_white, TEXT_ALIGN_CENTER)
end

function PANEL:PaintOver(w, h)
    self:PaintCursor(cursMat)
end

vgui.Register("LiteNetworkTerminal", PANEL, "Panel")
