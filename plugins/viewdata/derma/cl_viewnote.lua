--[[    © 2020 TERRANOVA do not share, re-distribute or modify    without permission of its author.--]]
local PANEL = {}

function PANEL:Init()
    self:Dock(FILL)
    self:SetPaintBackground(false)

    self.backHeader = self:Add(ix.gui.record:AddBackHeader(function()
        ix.gui.record:SendToServer(VIEWDATA_UPDATEVAR, {
            var = "note",
            info = self.textEntry:GetText()
        })

        ix.gui.record:SetStage("Home")
    end))

    local title = self:Add(ix.gui.record:BuildLabel("Editing Note", true))
    title:DockMargin(0, 0, 0, 4)
    local recordName = self:Add(ix.gui.record:BuildLabel("You can type up to 1024 characters."))
    recordName:DockMargin(0, 0, 0, 4)
    self.textEntry = self:Add("DTextEntry")
    self.textEntry:SetMultiline(true)
    self.textEntry:DockMargin(8, 0, 8, 8)
    self.textEntry:Dock(FILL)

    local record = ix.gui.record:GetRecord()
    local note = ""

    if record and record.vars then
        note = record.vars["note"] or ""
    end

    self.textEntry:SetText(note)

    function self.textEntry:PerformLayout()
        self:SetBGColor(Color(50, 50, 50, 50))
    end

    function self.textEntry:SetRealValue(text)
        self:SetValue(text)
        self:SetCaretPos(string.len(text))
    end

    function self.textEntry:Think()
        local text = self:GetValue()

        if string.len(text) > 1024 then
            self:SetRealValue(string.sub(text, 0, 1024))
            surface.PlaySound("common/talk.wav")
        end
    end
end

vgui.Register("ixCombineViewDataViewNote", PANEL, "DPanel")