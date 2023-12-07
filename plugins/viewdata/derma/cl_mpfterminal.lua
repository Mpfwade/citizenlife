local PANEL = {}

local function CursorStop(pan)
    pan:SetCursor("blank")

    for i, v in pairs(pan:GetChildren()) do
        CursorStop(v)
    end
end

function PANEL:Init()
    ix.gui.mpfTerminal = self
    self:SetSize(ScrW() / 1.3, ScrH() / 1.3)
    self:Center()
    self:MakePopup()
    local w, h = self:GetSize()
    self.list = vgui.Create("DListView", self)
    self.list:SetSize(w / 2, h)
    self.list:DockMargin(5, 5, 5, 5)
    self.list:Dock(LEFT)
    self.list:SetDataHeight(h / 24)
    self.list:AddColumn("Name")

    function self.list:Paint()
        surface.SetDrawColor(35, 35, 35, 245)
        surface.DrawRect(0, 0, w, h)
    end

    function self.list:OnRowSelected(ind, row)
        for i, v in ipairs(self:GetLines()) do
            v.selected = false
        end

        row.selected = true
        local par = self:GetParent()
        local ent = self.ents[ind]
        if not ent then return end
        local notes = ent:GetNetVar("notes", nil)
        -- Used to set whether or not buttons should be active
        par.selected = true
        par.selectedEnt = ent
        par.dockPanel:SetModel(ent)
        par.dockPanel.text:SetInfo(ent, notes)
    end

    for i, v in ipairs(self.list.Columns) do
        function v.Header:Paint(w, h)
            surface.SetDrawColor(120, 120, 120)
            surface.DrawRect(2, 2, w - 4, h - 4)
        end
    end

    self.dockPanel = vgui.Create("Panel", self)
    self.dockPanel:SetSize(w / 2.08)
    self.dockPanel:DockMargin(5, 5, 5, 5)
    self.dockPanel:Dock(FILL)

    function self.dockPanel:Paint(w, h)
        surface.SetDrawColor(35, 35, 35, 245)
        surface.DrawRect(0, 0, w, h)
    end

    local dock = self.dockPanel
    dock.modelPanel = vgui.Create("DModelPanel", dock)
    dock.modelPanel:SetSize(w / 3, h / 3)
    dock.modelPanel:SetPos(w / 12, 15)
    local cam = dock.modelPanel:GetCamPos()
    cam:Rotate(Angle(0, -35, 0))

    function dock:SetModel(ent)
        self.modelPanel:SetModel(ent:GetModel())
        self.modelPanel:SetLookAt(dock.modelPanel.Entity:GetBonePosition(dock.modelPanel.Entity:LookupBone("ValveBiped.Bip01_Head1")))
        self.modelPanel:SetFOV(30)
    end

    function dock.modelPanel:LayoutEntity()
        return
    end

    local oldDraw = dock.modelPanel.Paint
    local mat = Material("effects/com_shield002a")

    function dock.modelPanel:Paint(w, h)
        surface.SetDrawColor(25, 25, 25)
        surface.DrawRect(0, 0, w, h)

        if self.Entity then
            oldDraw(self, w, h)
            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h, 2)
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
        self:SetFontInternal("RadioFont")
    end

    function dock.text:SetInfo(ent)
        self:SetText("")
        self:InsertColorChange(255, 255, 255, 255)
        -- This is used later incase we need to refresh stored stuff
        local name = ent:GetName()
        self:AppendText("Subject Name:\n" .. name .. "\n\n")
        local character = ent:GetCharacter()
        local desc = character:GetDescription()
        self:AppendText("Physical Description:\n" .. desc .. "\n\n")
        local bol = ent:GetNWBool("ixActiveBOL")

        if bol then
            self:InsertColorChange(255, 0, 0, 255)
            bol = "MISCOUNT"
        else
            self:InsertColorChange(255, 255, 255, 255)
            bol = "MONITOR"
        end

        self:AppendText("Response Status: " .. bol .. "\n\n\n")
        self:InsertColorChange(255, 255, 255, 255)
    end

    dock.record = vgui.Create("DButton", dock)
    dock.record:SetSize(w / 8, h / 18)
    dock.record:SetPos(w / 32, h / 2.5)
    dock.record:SetText("View Record")
    local col = ix.config.Get("color", Color(0, 110, 230))

    function dock.record:Paint(w, h)
        local par = self:GetParent():GetParent()
        self.alpha = self.alpha or 0
        self.mult = self.mult or 0
        self.textCol = self.textCol or 150

        if par.selected then
            self.textCol = Lerp(0.02, self.textCol, 255)
        else
            self.textCol = Lerp(0.02, self.textCol, 150)
        end

        if self:IsHovered() then
            self.alpha = Lerp(0.02, self.alpha, 255)
            self.mult = Lerp(0.02, self.mult, 1)
        else
            self.alpha = Lerp(0.02, self.alpha, 0)
            self.mult = Lerp(0.02, self.mult, 0)
        end

        surface.SetDrawColor(90, 90, 90, 245)
        surface.DrawRect(0, 0, w, h)

        if par.selected then
            surface.SetDrawColor(col.r, col.g, col.b, self.alpha)
            -- I know they're not even, but they don't draw correctly unless I do this
            surface.DrawRect(0, h - (h / 12), w * self.mult, h / 10)
        end

        local textCol = Color(self.textCol, self.textCol, self.textCol, self.textCol)
        draw.SimpleText(self:GetText(), "RadioFont", w / 2, h / 2, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        return true
    end

    function dock.record:DoClick()
        local par = self:GetParent():GetParent()
        local ent = par.selectedEnt
        if not par.selected then return end
        RunConsoleCommand("say", "/viewdata " .. ent:GetName() .. "")
        surface.PlaySound("ui/buttonclick.wav")
    end

    dock.notes = vgui.Create("DButton", dock)
    dock.notes:SetSize(w / 8, h / 18)
    dock.notes:SetPos(w / 5.5, h / 2.5)
    dock.notes:SetText("Set BOL")

    function dock.notes:Paint(w, h)
        local par = self:GetParent():GetParent()
        self.alpha = self.alpha or 0
        self.mult = self.mult or 0
        self.textCol = self.textCol or 150

        if par.selected then
            self.textCol = Lerp(0.02, self.textCol, 255)
        else
            self.textCol = Lerp(0.02, self.textCol, 150)
        end

        if self:IsHovered() then
            self.alpha = Lerp(0.02, self.alpha, 255)
            self.mult = Lerp(0.02, self.mult, 1)
        else
            self.alpha = Lerp(0.02, self.alpha, 0)
            self.mult = Lerp(0.02, self.mult, 0)
        end

        surface.SetDrawColor(90, 90, 90, 245)
        surface.DrawRect(0, 0, w, h)

        if par.selected then
            surface.SetDrawColor(col.r, col.g, col.b, self.alpha)
            surface.DrawRect(0, h - (h / 12), w * self.mult, h / 10)
        end

        local textCol = Color(self.textCol, self.textCol, self.textCol, self.textCol)
        draw.SimpleText(self:GetText(), "RadioFont", w / 2, h / 2, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        return true
    end

    function dock.notes:DoClick()
        local par = self:GetParent():GetParent()
        local ent = par.selectedEnt
        if not IsValid(ent) then return end
        ent:SetNWBool("ixActiveBOL", true)
        surface.PlaySound("ui/buttonclick.wav")
    end

    dock.setBOL = vgui.Create("DButton", dock)
    dock.setBOL:SetSize(w / 8, h / 18)
    dock.setBOL:SetPos(w / 3, h / 2.5)
    dock.setBOL:SetText("Revoke BOL")

    function dock.setBOL:Paint(w, h)
        local par = self:GetParent():GetParent()
        self.alpha = self.alpha or 0
        self.mult = self.mult or 0
        self.textCol = self.textCol or 150

        if par.selected then
            self.textCol = Lerp(0.02, self.textCol, 255)
        else
            self.textCol = Lerp(0.02, self.textCol, 150)
        end

        if self:IsHovered() then
            self.alpha = Lerp(0.02, self.alpha, 255)
            self.mult = Lerp(0.02, self.mult, 1)
        else
            self.alpha = Lerp(0.02, self.alpha, 0)
            self.mult = Lerp(0.02, self.mult, 0)
        end

        surface.SetDrawColor(90, 90, 90, 245)
        surface.DrawRect(0, 0, w, h)

        if par.selected then
            surface.SetDrawColor(col.r, col.g, col.b, self.alpha)
            surface.DrawRect(0, h - (h / 12), w * self.mult, h / 10)
        end

        local textCol = Color(self.textCol, self.textCol, self.textCol, self.textCol)
        draw.SimpleText(self:GetText(), "RadioFont", w / 2, h / 2, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        return true
    end

    function dock.setBOL:DoClick()
        local par = self:GetParent():GetParent()
        local ent = par.selectedEnt
        if not IsValid(ent) then return end
        ent:SetNWBool("ixActiveBOL", false)
        surface.PlaySound("ui/buttonclick.wav")
    end

    self.close = vgui.Create("DButton", self)
    self.close:SetFont("ixSmallFont")
    self.close:SetSize(16, 16)
    self.close:SetPos((w - h / 64) - 5, 5)
    self.close:SetText("X")

    -- Using a dot instead of colon so self isn't overriden
    function self.close.DoClick()
        surface.PlaySound("ui/buttonclick.wav")
        self:Remove()
    end

    self:PopulateCitizens()
    CursorStop(self)
end

function PANEL:PopulateCitizens()
    self.list.ents = {}

    for i, v in ipairs(player.GetAll()) do
        if not v:IsCitizen() then continue end
        local char = v:GetCharacter()
        self.list:AddLine(v:GetName())
        self.list.ents[#self.list.ents + 1] = v
    end

    local col = ix.config.Get("color", Color(0, 110, 230))

    for i, v in ipairs(self.list:GetLines()) do
        function v:Paint(w, h)
            surface.SetDrawColor(90, 90, 90)
            surface.DrawRect(2, 2, w - 4, h - 2)
            self.alpha = self.alpha or 0
            self.mult = self.mult or 0

            if self:IsHovered() or self.selected then
                self.alpha = Lerp(0.02, self.alpha, 255)
                self.mult = Lerp(0.02, self.mult, 1)
            else
                self.alpha = Lerp(0.02, self.alpha, 0)
                self.mult = Lerp(0.02, self.mult, 0)
            end

            surface.SetDrawColor(col.r, col.g, col.b, self.alpha)
            surface.DrawRect(2, (h - h / 8) + 2, (w * self.mult) - 4, h / 8)
        end

        for i2, v2 in pairs(v.Columns) do
            v2:SetFont("RadioFont")
            v2:SetTextColor(Color(255, 255, 255, 20))

            function v2:Think()
                self.alpha = self.alpha or 20

                if self:GetParent():IsHovered() or self:GetParent().selected then
                    self.alpha = Lerp(0.02, self.alpha, 255)
                else
                    self.alpha = Lerp(0.02, self.alpha, 20)
                end

                self:SetTextColor(Color(255, 255, 255, self.alpha))
            end
        end
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