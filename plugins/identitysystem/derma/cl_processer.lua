local PANEL = {}
local PLUGIN = PLUGIN

function GetIndex(item)
	local cur = 1
	local text = item:GetData("paygrade", "Unemployed")

	for k, v in pairs(PLUGIN.paygrades) do
		if(k == text) then
			return cur
		end

		cur = cur + 1
	end

	return cur
end

function PANEL:Init()
	ix.gui.ccacreator = self

	self:SetSize(ScrW() / 4, 400)
	self:Center()
	self:SetTitle("")
	self:MakePopup()
	self:SetBackgroundBlur(true)

	self.toptext = self:AddLabel("Identification Registration Center", true)
	self.sourceText = self:AddLabel("Select a data source")

	self.itemswang = self:Add("DComboBox")
	self.itemswang:Dock(TOP)
	self.itemswang:SetValue("Select a source")
	
	self.characterTitle = self:AddLabel("Character details", true)
	self.nameText = self:AddLabel("Input Name")
	self.nameinput = self:Add("DTextEntry")
	self.nameinput:Dock(TOP)
	self.nameinput:DockMargin(16, 0, 16, 8)

	self.idtext = self:AddLabel("Input ID (Requires the citizen's ID on the Datapad!)")
	self.idinput = self:Add("DTextEntry")
	self.idinput:Dock(TOP)
	self.idinput:DockMargin(16, 0, 16, 8)
	self.idinput:SetUpdateOnType(true)
	self.idinput:SetNumeric(true)

	self.nameText = self:AddLabel("Home Assignment", true)

	self.idtext = self:AddLabel("Input Apartment Number (Requires two digits to be valid!)")
	self.jobTitle = self:Add("DTextEntry")
	self.jobTitle:Dock(TOP)
	self.jobTitle:DockMargin(16, 0, 16, 8)
	self.jobTitle:SetUpdateOnType(true)
	self.jobTitle:SetNumeric(true)

	for k, v in pairs(LocalPlayer():GetCharacter():GetInventory():GetItems()) do
		if(v.uniqueID == "cid" or v.uniqueID == "cid") then
			local name = "ID"

			if(v.uniqueID == "cid") then
				name = "TRANSFER"
			end

			self.itemswang:AddChoice(string.format("%s - %s", name, v:GetData("citizen_name", "error")), {v})
		end
	end

	function self.idinput:Think()
		local text = self:GetValue();
		
		if (string.len(text) > 5) then
			self:SetValue( string.sub(text, 0, 5) );
			ix.gui.ccacreator.nameinput:RequestFocus()

			surface.PlaySound("common/talk.wav");
		end;
	end;

	function self.jobTitle:Think()
		local text = self:GetValue();
		
		if (string.len(text) > 2) then
			self:SetValue( string.sub(text, 0, 2) );
			ix.gui.ccacreator.nameinput:RequestFocus()

			surface.PlaySound("common/talk.wav");
		end;
	end;

	self.itemswang.OnSelect = function(self, index, value, data)
		local item = data[1]

		ix.gui.ccacreator.nameinput:SetText(item:GetData("citizen_name", "error"))
		ix.gui.ccacreator.idinput:SetValue(item:GetData("cid", 99999))
		ix.gui.ccacreator.jobTitle:SetText(item:GetData("unique", 20))
		ix.gui.ccacreator.item = item
	end

	self.submitbutton = self:Add("DButton")
	self.submitbutton:Dock(BOTTOM)
	self.submitbutton:SetText("Submit")

	self:InvalidateLayout(true)
	self:SizeToChildren(false, true)

	function self.submitbutton:DoClick()
		if(!string.len(ix.gui.ccacreator.idinput:GetText()) == 5) then
			LocalPlayer():Notify("The CID must contain 5 digits.")
			return
		end

		local data = {
			ix.gui.ccacreator.nameinput:GetText(),
			ix.gui.ccacreator.idinput:GetText(),
			ix.gui.ccacreator.paygradeName or "Unemployed",
			ix.gui.ccacreator.salary or 0
		}

		if(ix.gui.ccacreator.item) then
			data.item = ix.gui.ccacreator.item.id
		end

		if(string.len(ix.gui.ccacreator.jobTitle:GetText()) >= 1) then
			table.insert(data, ix.gui.ccacreator.jobTitle:GetText())
		end

		netstream.Start("SubmitNewCCA", data)

		ix.gui.ccacreator:Remove()
	end
end

function PANEL:AddLabel(text, colored)
	local label = self:Add("DLabel")
	label:SetContentAlignment(5)
	label:Dock(TOP)
	label:SetText(text)
	label:SetExpensiveShadow(2)
	label:SetFont("ixSmallFont")

    if(colored) then
        label:SetTextColor(ix.config.Get("color"))
	end
	
	return label
end

vgui.Register("ixCCACreater", PANEL, "DFrame")