include("shared.lua")

function ENT:Initialize()
    self.playerFaction = FACTION_CCA
end

local PANEL = {}

function PANEL:Init()
    self:SetSize(600, 500)
    self:Center()
    self:SetTitle("Division and Rank selection")
    self:MakePopup()
    self.selectedDivision = nil
    self.selectedDivisionID = nil
    self.selectedRank = nil
    self.selectedRankID = nil
    self.modelPreview = self:Add("ixModelPanel")
    self.modelPreview:SetSize(self:GetWide() / 2, 0)
    self.modelPreview:Dock(RIGHT)
    self.modelPreview:SetFOV(45)
    self.modelPreview:SetModel(LocalPlayer():GetModel(), LocalPlayer():GetSkin())
    self.modelPreview:MoveToBack()
    self.modelPreview:SetCursor("arrow")
    self.divisionText = self:Add("ixLabel")
    self.divisionText:SetFont("ixMediumFont")
    self.divisionText:SetText("Divison:")
    self.divisionText:SetContentAlignment(4)
    self.divisionText:SizeToContents()
    self.divisionText:DockMargin(5, 0, 0, 0)
    self.divisionText:Dock(TOP)
    self.divisionBox = self:Add("DComboBox")
    self.divisionBox:SetFont("ixSmallFont")
    self.divisionBox:SetSortItems(false)
    self.divisionBox:SetValue("Select a divison")
    self.divisionBox:SizeToContents()
    self.divisionBox:Dock(TOP)
    local xp = tonumber(LocalPlayer():GetRP())

    for k, v in pairs(ix.divisions.cca) do
        if not (v.xp == nil) then
            if xp >= v.xp then
                self.divisionBox:AddChoice(ix.divisions.cca[k].name .. " - " .. ix.divisions.cca[k].description .. " - " .. ix.divisions.cca[k].xp .. " RP", k, false, "icon16/tick.png")
            else
                self.divisionBox:AddChoice(ix.divisions.cca[k].name .. " - " .. ix.divisions.cca[k].description .. " - " .. ix.divisions.cca[k].xp .. " RP", k, false, "icon16/cross.png")
            end
        else
            self.divisionBox:AddChoice(ix.divisions.cca[k].name .. " - " .. ix.divisions.cca[k].description .. " - WHITELISTED", k, false, "icon16/lock.png")
        end
    end

    self.divisionBox.OnSelect = function(panel, index, value)
        self.selectedDivision = value
        self.selectedDivisionID = index
    end

    self.rankText = self:Add("ixLabel")
    self.rankText:SetFont("ixMediumFont")
    self.rankText:SetText("Rank:")
    self.rankText:SetContentAlignment(4)
    self.rankText:SizeToContents()
    self.rankText:DockMargin(5, 0, 0, 0)
    self.rankText:Dock(TOP)
    self.rankBox = self:Add("DComboBox")
    self.rankBox:SetFont("ixSmallFont")
    self.rankBox:SetSortItems(false)
    self.rankBox:SetValue("Select a rank")
    self.rankBox:SizeToContents()
    self.rankBox:Dock(TOP)

    for k, v in pairs(ix.ranks.cca) do
        if not (v.xp == nil) then
            if xp >= v.xp then
                self.rankBox:AddChoice(ix.ranks.cca[k].name .. " - " .. ix.ranks.cca[k].description .. " - " .. ix.ranks.cca[k].xp .. " RP", k, false, "icon16/tick.png")
            else
                self.rankBox:AddChoice(ix.ranks.cca[k].name .. " - " .. ix.ranks.cca[k].description .. " - " .. ix.ranks.cca[k].xp .. " RP", k, false, "icon16/cross.png")
            end
        else
            self.rankBox:AddChoice(ix.ranks.cca[k].name .. " - " .. ix.ranks.cca[k].description .. " - WHITELISTED", k, false, "icon16/lock.png")
        end
    end

    self.rankBox.OnSelect = function(panel, index, value)
        self.selectedRank = value
        self.selectedRankID = index
    end

    self.doneButton = self:Add("ixMenuButton")
    self.doneButton:SetFont("ixSmallFont")
    self.doneButton:SetText("no divison or rank selected")
    self.doneButton:SetContentAlignment(5)
    self.doneButton:SetDisabled(true)
    self.doneButton:SizeToContents()
    self.doneButton:Dock(BOTTOM)

    self.doneButton.Think = function()
        -- again.. very un-efficient but still.. WHO CARES!!!
        if not ((self.divisionBox and self.divisionBox:GetValue():find("Select")) or (self.rankBox and self.rankBox:GetValue():find("Select"))) then
            self.doneButton:SetText("become a " .. ix.divisions.cca[self.selectedDivisionID].name .. " " .. ix.ranks.cca[self.selectedRankID].name)
            self.doneButton:SetDisabled(false)

            return
        end

        self.doneButton:SetDisabled(true)
        self.doneButton:SetText("no divison or rank selected")
    end

    self.doneButton.DoClick = function()
        RunConsoleCommand("ix_selector_cca", self.selectedRankID, self.selectedDivisionID, self.randomUnitID) -- i use console commands since.. backdoorers keep making everything un-fun.
        self:Remove()
    end

function PANEL:Paint(w, h)
    surface.SetDrawColor(Color(30, 30, 30, 200))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(ix.config.Get("color"))
    surface.DrawRect(0, 0, w, 24)
    surface.DrawOutlinedRect(0, 0, w, h, 5)
    ix.util.DrawBlur(self, 1)
    end
end

vgui.Register("LiteNetwork.RankMenu.CCA", PANEL, "DFrame")