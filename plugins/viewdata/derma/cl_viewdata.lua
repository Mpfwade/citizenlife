--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]
local PLUGIN = PLUGIN
local PANEL = {}

local function CursorStop(pan)
    pan:SetCursor("blank")

    for i, v in pairs(pan:GetChildren()) do
        CursorStop(v)
    end
end

-- Called when the panel is first initialized.
function PANEL:Init()
    if IsValid(ix.gui.menu) then
        ix.gui.menu:Remove()
    end

    CursorStop(self)
    self:SetBackgroundBlur(true)
    self:ShowCloseButton(false)
    self:Center()
    self:MakePopup()
    self:SetTitle("")
    self:SetAlpha(0)
    self.exitButton = self:Add("DButton")
    self.exitButton:SetFont("ixSmallFont")
    self.exitButton:SetSize(16, 16)
    self.exitButton:SetPos(480, 16)
    self.exitButton:SetText("X")

    function self.exitButton:DoClick()
        surface.PlaySound("ui/buttonclick.wav")

        ix.gui.record:SendToServer(VIEWDATA_UPDATEVAR, {
            var = "note",
            info = ix.gui.record.note.textEntry:GetText()
        })

        ix.gui.record:Remove()
    end
end

-- Called each frame of the panel being open.
function PANEL:Think()
    local scrW = ScrW()
    local scrH = ScrH()
    self:SetSize(512, 512)
    self:SetPos((scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2))
end

function PANEL:AddStage(text, panelType)
    local panel = self:Add(panelType or "DPanel")
    panel:Dock(FILL)
    panel:DockMargin(16, 0, 16, 16)
    panel:SetVisible(false)

    if not self.stages then
        self.stages = {}
    end

    self.stages[text] = panel

    return panel
end

function PANEL:SetStage(text)
    if not self.stages[text] then return end

    for k, v in pairs(self.stages) do
        if k ~= text then
            v:SetVisible(false)
        else
            v:SetVisible(true)
        end
    end
end

-- Called when the panel is receiving data and will start to build.
function PANEL:Build(target, cid, record)
    self.target = target
    self.character = target:GetCharacter()
    self.cidValue = cid
    self.recordTable = record
    self.content = self:AddStage("Home")
    self.content:SetPaintBackground(false)
    self:BuildCID()
    self.record = self:AddStage("Record", "ixCombineViewDataRecord")
    self.note = self:AddStage("Note", "ixCombineViewDataViewNote")
    self.unitrecord = self:AddStage("UnitRecord", "ixCombineViewDataUnitRecord")
    self.vars = self:AddStage("EditData", "ixCombineViewDataEditData")
    self:SetStage("Home")
    self:AlphaTo(255, 0.5)
    self:BuildButtons()
    CursorStop(self)
end

function PANEL:GetRecord()
    return self.recordTable or {
        rows = {},
        vars = {
            ["note"] = PLUGIN.defaultNote
        }
    }
end

function PANEL:BuildCID()
    self.cid = self.content:Add("DPanel")
    self.cid:Dock(TOP)
    self.cid:DockMargin(0, 8, 0, 8)
    self.cid:SetTall(196)
    self.cid:SetPaintBackground(false)
    self.modelBackground = self.cid:Add(self:DrawCharacter())
    self.rightDock = self.cid:Add("DPanel")
    self.rightDock:Dock(FILL)
    self.rightDock:DockMargin(8, 16, 16, 16)
    self.rightDock:SetPaintBackground(false)
    self.name = self.rightDock:Add(self:BuildLabel("Name : " .. self.character:GetName() or "Error", false, 4))
    self.cid = self.rightDock:Add(self:BuildLabel("CID : " .. self.cidValue or "ERROR", false, 4))
    CursorStop(self)
end

function PANEL:BuildButtons()
    self.buttonLayout = self.content:Add("DIconLayout")
    self.buttonLayout:Dock(FILL)
    self.buttonLayout:DockMargin(0, 4, 0, 4)
    self.buttonLayout:SetSpaceX(4)
    self.buttonLayout:SetSpaceY(4)
    self.buttonLayout:SetStretchWidth(true)
    self.buttonLayout:SetStretchHeight(true)
    self.buttonLayout:InvalidateLayout(true)
    self.buttonLayout:Add(self:AddStageButton("View Note", "Note"))
    self.buttonLayout:Add(self:AddStageButton("View Application", "Application"))
end

function PANEL:DrawCharacter(small)
    local modelBackground = vgui.Create("DPanel")
    modelBackground:Dock(LEFT)

    if not small then
        modelBackground:SetSize(180, 180)
        modelBackground:DockMargin(16, 16, 16, 16)
    end

    function modelBackground:Paint(w, h)
        surface.SetDrawColor(25, 25, 25, 225)
        surface.DrawRect(0, 0, w, h)
        surface.SetMaterial(ix.util.GetMaterial("citizenlifestuff/male04silhouette.png"))
        surface.SetDrawColor(255, 255, 255, 225)
        surface.DrawTexturedRect(0, 0, w, h)
        surface.SetDrawColor(90, 90, 90, 255)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    return modelBackground
end

function PANEL:BuildLabel(text, title, align, overrideFont)
    local label = self:Add("DLabel")
    local font = "RadioFont"

    if title then
        font = "ixBigFont"
    end

    font = overrideFont or font
    label:SetContentAlignment(align or 5)
    label:SetFont(font)
    label:SetText(text)
    label:Dock(TOP)
    label:SizeToContents()
    label:SetExpensiveShadow(3)
    CursorStop(self)

    return label
end

function PANEL:AddStageButton(name, parent)
    local button = vgui.Create("DButton")
    button:SetSize(233, 100)
    button:SetText(name)

    function button.DoClick()
        ix.gui.record:SetStage(parent)
        surface.PlaySound("ui/buttonclick.wav")
    end

    return button
end

function PANEL:AddBackHeader(callback)
    local header = vgui.Create("DPanel")
    header:Dock(TOP)
    header:SetTall(32)
    header:DockMargin(0, 0, 0, 4)
    header:SetPaintBackground(false)
    local model = header:Add(self:DrawCharacter(true))
    model:SetSize(32, 32)
    model:DockMargin(4, 4, 4, 4)
    local back = header:Add("DButton")
    back:Dock(LEFT)
    back:DockMargin(2, 2, 2, 2)
    back:SetText("Back")

    function back.DoClick()
        if not callback then
            surface.PlaySound("ui/buttonclick.wav")
            ix.gui.record:SetStage("Home")
        else
            surface.PlaySound("ui/buttonclick.wav")
            callback()
        end
    end

    return header
end

function PANEL:PaintCursor(mat)
    local x, y = self:LocalCursorPos()
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(mat)
    surface.DrawTexturedRect(x, y, 25, 25)
end

local cursMat = Material("vgui/cursors/arrow")

function PANEL:Paint(w, h)
    surface.SetDrawColor(40, 40, 40, 245)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:PaintOver(w, h)
    self:PaintCursor(cursMat)
end

function PANEL:SendToServer(message, data)
    if not message or not data or not self.character then
        ErrorNoHalt("Could not send viewdata mesage to server because data or target character is missing.")

        return
    end

    net.Start("ixViewDataAction")
    net.WriteInt(self.character.id, 32)
    net.WriteInt(message, 16)
    net.WriteTable(data)
    net.SendToServer()
end

vgui.Register("ixCombineViewData", PANEL, "DFrame")