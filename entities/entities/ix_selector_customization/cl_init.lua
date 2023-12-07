include("shared.lua")

net.Receive("ixSelector.Customizer.NotAllowed", function()
    Derma_Message("You need to become a Civilian in order to use this vendor!", "Civilian Customizer", "X")
end)

local PANEL = {}

function PANEL:Init()
    self:SetSize(600, 500)
    self:Center()
    self:SetTitle("Civilian Customizer")
    self:MakePopup()
    self.selectedskin = nil
    self.selectedskinID = nil
    self.modelPreview = self:Add("ixModelPanel")
    self.modelPreview:SetSize(self:GetWide() / 2, 0)
    self.modelPreview:Dock(RIGHT)
    self.modelPreview:SetFOV(45)
    self.modelPreview:SetModel(LocalPlayer():GetModel(), LocalPlayer():GetSkin())
    self.modelPreview:MoveToBack()
    self.modelPreview:SetCursor("arrow")
    self.skinsText = self:Add("ixLabel")
    self.skinsText:SetFont("ixMediumFont")
    self.skinsText:SetText("skins:")
    self.skinsText:SetContentAlignment(4)
    self.skinsText:SizeToContents()
    self.skinsText:DockMargin(5, 0, 0, 0)
    self.skinsText:Dock(TOP)
    self.skinsBox = self:Add("DComboBox")
    self.skinsBox:SetFont("ixSmallFont")
    self.skinsBox:SetSortItems(false)
    self.skinsBox:SetValue("Select a skin")
    self.skinsBox:SizeToContents()
    self.skinsBox:Dock(TOP)
    local xp = tonumber(LocalPlayer():GetXP())

    for k, v in pairs(ix.divisions.citizen) do
        if xp >= v.xp then
            self.skinsBox:AddChoice(ix.divisions.citizen[k].name .. " - " .. ix.divisions.citizen[k].xp .. " XP", k, false, "icon16/tick.png")
        else
            self.skinsBox:AddChoice(ix.divisions.citizen[k].name .. " - " .. ix.divisions.citizen[k].xp .. " XP", k, false, "icon16/cross.png")
        end
    end

    self.skinsBox.OnSelect = function(panel, index, value)
        self.selectedskin = value
        self.selectedskinID = index
    end

    self.doneButton = self:Add("ixMenuButton")
    self.doneButton:SetFont("ixSmallFont")
    self.doneButton:SetText("no skin selected")
    self.doneButton:SetContentAlignment(5)
    self.doneButton:SetDisabled(true)
    self.doneButton:SizeToContents()
    self.doneButton:Dock(BOTTOM)

    self.doneButton.Think = function()
        -- again.. very un-efficient but still.. WHO CARES!!!
        if not (self.skinsBox and self.skinsBox:GetValue():find("Select")) then
            self.doneButton:SetText("become a " .. ix.divisions.citizen[self.selectedskinID].name)
            self.doneButton:SetDisabled(false)

            return
        end

        self.doneButton:SetDisabled(true)
        self.doneButton:SetText("no skin selected")
    end

    self.doneButton.DoClick = function()
        RunConsoleCommand("ix_selector_citizen", self.selectedskinID) -- i use console commands since.. backdoorers keep making everything un-fun.
        self:Remove()
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(Color(30, 30, 30, 200))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(ix.config.Get("color"))
    surface.DrawRect(0, 0, w, 24)
    surface.DrawOutlinedRect(0, 0, w, h, 5)
    ix.util.DrawBlur(self, 1)
end

vgui.Register("LiteNetwork.Menu.Customizer", PANEL, "DFrame")