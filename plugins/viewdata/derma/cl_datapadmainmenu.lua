local PANEL = {}

local function CursorStop(pan)
    pan:SetCursor("blank")

    for i, v in pairs(pan:GetChildren()) do
        CursorStop(v)
    end
end

function PANEL:Init()
    ix.gui.DataPadMainMenu = self
    self:SetSize(ScrW() / 1.3, ScrH() / 1.3)
    self:Center()
    self:MakePopup()
    local w, h = self:GetSize()
    self.list = vgui.Create("DListView", self)
    self.list:SetSize(w / 2, h)
    self.list:DockMargin(5, 5, 5, 5)
    self.list:Dock(LEFT)
    self.list:SetDataHeight(h / 24)
    self.dockPanel = vgui.Create("Panel", self)
    self.dockPanel:SetSize(w / 2.08)
    self.dockPanel:DockMargin(5, 5, 5, 5)
    self.dockPanel:Dock(FILL)

    function self.dockPanel:Paint(w, h)
        surface.SetDrawColor(35, 35, 35, 245)
        surface.DrawRect(0, 0, w, h)
    end

    dock.textDock = vgui.Create("Panel", dock)
    dock.textDock:SetSize(w / 2 - 40, h / 2 - 40)
    dock.textDock:SetPos(10, h / 2)

    function dock.textDock:Paint(w, h)
        surface.SetDrawColor(50, 50, 50)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    dock.text = vgui.Create("RichText", dock.textDock)
    dock.text:Dock(FILL)

    function dock.text:PerformLayout()
        self:SetFontInternal("Trebuchet24")
    end

    self.close = vgui.Create("DButton", self)
    self.close:SetFont("ixSmallFont")
    self.close:SetSize(16, 16)
    self.close:SetPos((w - h / 64) - 5, 5)
    self.close:SetText("X")

    -- Using a dot instead of colon so self isn't overriden
    function self.close.DoClick()
        self:Remove()
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
    surface.SetDrawColor(40, 40, 40, 245)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:PaintOver(w, h)
    self:PaintCursor(cursMat)
end

vgui.Register("ixMPFTerminal", PANEL, "Panel")