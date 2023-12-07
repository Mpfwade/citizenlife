include("shared.lua")

local glowMaterial = Material("sprites/glow04_noz")

local MenuWidth = 454

-- ENUMS
local COLOR_RED = 1
local COLOR_ORANGE = 2
local COLOR_BLUE = 3
local COLOR_GREEN = 4

local colors = {
	[COLOR_RED] = Color(255, 50, 50),
	[COLOR_ORANGE] = Color(255, 80, 20),
	[COLOR_BLUE] = Color(50, 80, 230),
	[COLOR_GREEN] = Color(50, 240, 50)
}

local STATE_IDLE = 1
local STATE_CHECKING = 2
local STATE_ERROR = 3
local STATE_SUCCESFUL = 4
local STATE_OPENED = 5
local STATE_CLOSING = 6
local STATE_DISABLED = 7


local ColorStates = {
	[STATE_IDLE] = COLOR_GREEN,
	[STATE_CHECKING] = COLOR_BLUE,
	[STATE_ERROR] = COLOR_RED,
	[STATE_SUCCESFUL] = COLOR_GREEN,
	[STATE_OPENED] = COLOR_BLUE,
	[STATE_CLOSING] = COLOR_RED,
	[STATE_DISABLED] = COLOR_RED
}


surface.CreateFont( "civil_terminal", {
	font = "Tahoma", -- "Gypsy killer condensed", --"akashi", -- "prototype", -- "digital-7 mono",
	size = 28,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function ENT:GetTxt()
	local prefix = ""
	if self:GetState() == STATE_ERROR then
		prefix = L("apartsContrlTermErr") .. "\r\n"
	end
	local txt = L(unpack(string.Explode(";", self:GetText())))
	--txt = string.upper(txt)

	surface.SetFont("civil_terminal")
	local w, _ = surface.GetTextSize(txt)
	if w > (MenuWidth - (10 * 2)) then
		local txttbl = string.Explode(" ", txt)

		local endtxt = ""
		local graphtext = ""
		local done = false
		for k, v in pairs(txttbl) do
			endtxt = endtxt .. v
			graphtext = graphtext .. v
			local nospace = false

			local w, _ = surface.GetTextSize(graphtext .. (txttbl[k + 1] and txttbl[k + 1] or ""))
			if w > 370 then
				endtxt = endtxt .. "\r\n"
				graphtext = ""
				nospace = true
				done = true
			end

			if (not nospace) and k < #txttbl then
				endtxt = endtxt .. " "
				graphtext = graphtext .. " "
			end
		end
		txt = endtxt
	end
	return prefix .. txt
end

local offset = 10
local chance = 2000

local timeStatic = 0.05
local timeStaticEnd = 0.1

local offdiv = offset / 2

local letterOffset = {}
local linestext = {}
local function SimpleChopyText( text, font, line, x, y, colour, xalign, yalign )
	text	= tostring( text )
	font	= font		or "DermaDefault"
	x		= x			or 0
	y		= y			or 0
	xalign	= xalign	or TEXT_ALIGN_LEFT
	yalign	= yalign	or TEXT_ALIGN_TOP

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	if ( xalign == TEXT_ALIGN_CENTER ) then
		x = x - w / 2
	elseif ( xalign == TEXT_ALIGN_RIGHT ) then
		x = x - w
	end

	if ( yalign == TEXT_ALIGN_CENTER ) then
		y = y - h / 2
	elseif ( yalign == TEXT_ALIGN_BOTTOM ) then
		y = y - h
	end

	if not linestext[line] then
		linestext[line] = text
	end
	if linestext[line] != text then
		if string.StartWith(text, linestext[line]) then
			local len = string.len(linestext[line])
			if string.sub(text, len + 1, len + 1) != "." then
				linestext[line] = text
			end
		else
			linestext[line] = text
			letterOffset[line] = {}
		end
	end

	letterOffset[line] = letterOffset[line] or {}
	local curOffset = letterOffset[line]
	for i = 1, string.len(text) do
		if curOffset[i] and curOffset[i].time < CurTime() then
			curOffset[i] = nil
		end

		local choppyInfo = {0, 0}
		if curOffset[i] then
			choppyInfo = {curOffset[i].x, curOffset[i].y}
		elseif math.random(1, chance) == 1 then
			curOffset[i] = {x = math.random(0, offset) - offdiv, y = math.random(0, offset) - offdiv, time = CurTime() + math.random(timeStatic, timeStaticEnd)}
			choppyInfo = {curOffset[i].x, curOffset[i].y}
		end

		surface.SetTextPos( math.ceil( x ) + choppyInfo[1], math.ceil( y ) + choppyInfo[2] )
		if ( colour != nil ) then
			local alpha = 255
			if ( colour.a ) then alpha = colour.a end
			surface.SetTextColor( colour.r, colour.g, colour.b, alpha )
		else
			surface.SetTextColor( 255, 255, 255, 255 )
		end
		local letter = string.sub(text, i, i)
		surface.DrawText(letter)
		x = x + surface.GetTextSize(letter)
	end

	return w, h
end


local function DrawChopyText( text, font, x, y, colour, xalign )
	if ( font == nil ) then font = "DermaDefault" end
	if ( text != nil ) then text = tostring( text ) end
	if ( x == nil ) then x = 0 end
	if ( y == nil ) then y = 0 end

	local curX = x
	local curY = y
	local curString = ""

	surface.SetFont( font )
	local sizeX, lineHeight = surface.GetTextSize( "\n" )
	local tabWidth = 50

	local line = 1
	for str in string.gmatch( text, "[^\n]*" ) do
		if #str > 0 then
			if string.find( str, "\t" ) then -- there's tabs, some more calculations required
				for tabs, str2 in string.gmatch( str, "(\t*)([^\t]*)" ) do
					curX = math.ceil( ( curX + tabWidth * math.max( #tabs - 1, 0 ) ) / tabWidth ) * tabWidth

					if #str2 > 0 then
						SimpleChopyText( str2, font, line, curX, curY, colour, xalign )

						local w, _ = surface.GetTextSize( str2 )
						curX = curX + w
					end
				end
			else -- there's no tabs, this is easy
				SimpleChopyText( str, font, line, curX, curY, colour, xalign )
			end
		else
			curX = x
			curY = curY + ( lineHeight / 2 )
		end
		line = line + 1
	end
end

function ENT:Think()
	if self.LastErrorText != self:GetText() then
		self.LastErrorTextLen = 0
		self.LastErrorTextTime = CurTime() + 0.05
		self.EndFix = self.EndFix or {0, CurTime() + 1}
		self.EndFix[1] = 0
	end
	if self.LastErrorTextTime < CurTime() and string.len(self:GetTxt()) > self.LastErrorTextLen then
		self.LastErrorTextLen = self.LastErrorTextLen + 1
		self.LastErrorTextTime = self.LastErrorTextTime + 0.05
		self:EmitSound("common/talk.wav")
	elseif self.LastErrorTextLen >= string.len(self:GetTxt()) and self:GetState() == STATE_IDLE then
		self.EndFix = self.EndFix or {0, CurTime() + 1}

		if self.EndFix[2] < CurTime() then
			self.EndFix[1] = self.EndFix[1] < 3 and self.EndFix[1] + 1 or 0
			self.EndFix[2] = CurTime() + 1
		end
	end

	self:NextThink(CurTime())
	return true
end

-- local scanline = Material("catiwis/scanline") --("ds_gunhud/ds_scanlines") --("catiwis/scanline")
--[[
local params = {
	[ "$basetexture" ] = "dev/dev_scanline",
	[ "$translucent" ] = 1,
	[ "$vertexalpha" ] = 1,
	[ "$vertexcolor" ] = 1,
	Proxies = {
		AnimatedTexture = {
			animatedtexturevar = "$basetexture",
			animatedtextureframenumvar = "$frame",
			animatedtextureframerate = "15"
		}
	}
}

local scanline = CreateMaterial("effects/monitorscreen_scanline1a_terminalcivil", "UnlitGeneric", params) --]]

local BackgroundFade = {
	Color(10, 10, 200),
	Color(231, 76, 60),
	Color(46, 204, 113)
}

local function ColApproach(appr, clr, clr2)
	local rApp = clr2.r - clr.r
	local gApp = clr2.g - clr.g
	local bApp = clr2.b - clr.b

	rApp, gApp, bApp = rApp * appr, gApp * appr, bApp * appr
	return Color(clr.r + rApp, clr.g + gApp, clr.b + bApp)
end

local matBlurScreen = Material( "effects/combinedisplay001b" )

hook.Add("PhysgunPickup", "CivilTerminalPickup", function(ply, ent)
	if ent:GetClass():lower() == "ix_civil_terminal" then
		ent.Physgun = true
	end
end)

hook.Add("PhysgunDrop", "CivilTerminalDrop", function(ply, ent)
	if ent:GetClass():lower() == "ix_civil_terminal" then
		timer.Simple(0.3, function()
			if IsValid(ent) then
				ent.Physgun = false
			end
		end)
	end
end)

function ENT:Draw()
	self:DrawModel()

	local position = self:GetPos()
	local forward = self:GetForward() * 5
	local curTime = CurTime()
	local right = self:GetRight() * -10
	local up = self:GetUp() * 43

	local glowColor = colors[ColorStates[self:GetState()]]

	cam.Start3D( EyePos(), EyeAngles() )
		render.SetMaterial(glowMaterial)
		render.DrawSprite(position + forward + right + up, 20, 20, glowColor)
	cam.End3D()

	local angles = self:GetAngles()
	angles:RotateAroundAxis(angles:Up(), 90)
	angles:RotateAroundAxis(angles:Forward(), 90)
	local pos = self:GetPos() + (self:GetUp() * 68) + (self:GetForward() * -4.2) + (self:GetRight() * 32)
	cam.Start3D2D(pos, angles, 0.1)
		-- Color fading
		self.FadeColor = self.FadeColor or BackgroundFade[1]
		self.NextFade = self.NextFade or 2
		self.ColApproach = self.ColApproach or 0

		local nextCol = BackgroundFade[self.NextFade]
		if self.ColApproach == 1 then--if math.Round(self.FadeColor.r, 0) == nextCol.r and math.Round(self.FadeColor.g, 0) == nextCol.g and math.Round(self.FadeColor.b, 0) == nextCol.b then
			self.NextFade = self.NextFade + 1
			self.ColApproach = 0
			if self.NextFade > #BackgroundFade then
				self.NextFade = 1
			end
		end

		self.ColApproach = math.Approach(self.ColApproach, 1, FrameTime() * 0.05)
		--print(self.ColApproach)
		self.FadeColor = ColApproach(self.ColApproach or 0, BackgroundFade[(self.NextFade > 1) and self.NextFade - 1 or #BackgroundFade], BackgroundFade[self.NextFade])

		--self.FadeColor = VecToCol(LerpVector(FrameTime() * 0.2, ColToVec(self.FadeColor or BackgroundFade[1]), ColToVec(BackgroundFade[self.NextFade or 2])))

		------------------
		-- CALCULUS END --
		------------------

		-- Drawing blur
		if not self.Physgun then
			surface.SetMaterial(matBlurScreen)
			surface.SetDrawColor(255, 255, 255, 255)

			local pass = 0.2
			local ammount = 10

			for i = -pass, 1, 0.2 do
				matBlurScreen:SetFloat("$blur", i * ammount)
				matBlurScreen:Recompute()
				render.UpdateFullScreenDepthTexture()
				render.UpdatePowerOfTwoTexture()
				render.UpdateRefractTexture()
				if (render) then render.UpdateScreenEffectTexture() end -- Todo: Make this available to menu Lua
				surface.DrawTexturedRect(0, 0, MenuWidth, 200)
			end
		end


		-- Drawing starts here
		local clr = self.FadeColor or Color(10, 10, 200)
		surface.SetDrawColor(clr.r, clr.g, clr.b, 30)
		surface.DrawRect(0, 0, MenuWidth, 200)

		--surface.SetMaterial(scanline)
		--surface.SetDrawColor(60, 60, 255, 255) --surface.SetDrawColor(255, 255, 255, 255)
		--surface.DrawTexturedRect(0, 0, MenuWidth, 200)

		if self:GetText() and self:GetText() != "" then
			local endfix = ""
			if (self.LastErrorTextLen or 0) >= string.len(self:GetTxt()) and self:GetState() == STATE_IDLE then
				endfix = "..."
			end

			local stateclr = Color(255, 255, 255)
			if self:GetState() == STATE_ERROR then
				stateclr = Color(231, 76, 60)
			elseif self:GetState() == STATE_DISABLED then
				stateclr = Color(231, 76, 60) --Color(192, 57, 43)
			end
			--print(self:GetTxt())
			DrawChopyText(string.sub(self:GetTxt() .. endfix, 0, (self.LastErrorTextLen or 0) + (self.EndFix and self.EndFix[1] or 0)), "civil_terminal", 10, 10, stateclr, TEXT_ALIGN_LEFT)
		end
		self.LastErrorText = self:GetText()

	cam.End3D2D()
end

local function DermaQueryCustom( strText, strTitle, ... )
	local Window = vgui.Create( "DFrame" )
	Window:SetTitle( strTitle or "Message Title (First Parameter)" )
	Window:SetDraggable( false )
	Window:ShowCloseButton( false )
	Window:SetBackgroundBlur( true )
	Window:SetDrawOnTop( true )

	local InnerPanel = vgui.Create( "DPanel", Window )
	InnerPanel:SetPaintBackground( false )

	local Text = vgui.Create( "DLabel", InnerPanel )
	Text:SetText( strText or "Message Text (Second Parameter)" )
	Text:SizeToContents()
	Text:SetContentAlignment( 5 )
	Text:SetTextColor( color_white )

	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )
	ButtonPanel:SetPaintBackground( false )

	-- Loop through all the options and create buttons for them.
	local NumOptions = 0
	local x = 5

	for k = 1, #{...}, 2 do
		local Text = select( k, ... )
		if Text == nil then break end

		local Func = select( k + 1, ... ) or function() end

		local Button = vgui.Create( "DButton", ButtonPanel )
		Button:SetText( Text )
		Button:SizeToContents()
		Button:SetTall( 20 )
		Button:SetWide( Button:GetWide() + 20 )
		Button.DoClick = function() Window:Close() Func() end
		Button:SetPos( x, 5 )

		x = x + Button:GetWide() + 5

		ButtonPanel:SetWide( x )
		NumOptions = NumOptions + 1

	end

	local w, h = Text:GetSize()

	w = math.max( w, ButtonPanel:GetWide() )

	Window:SetSize( w + 50, h + 25 + 45 + 10 )
	Window:Center()

	InnerPanel:StretchToParent( 5, 25, 5, 45 )

	Text:StretchToParent( 5, 5, 5, 5 )

	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )

	Window:MakePopup()
	Window:DoModal()

	if ( NumOptions == 0 ) then
		Window:Close()
		Error( "Derma_Query: Created Query with no Options!?" )
		return nil
	end

	return Window
end

net.Receive("ix_civil_terminal_request", function(len, ply)
	if not LocalPlayer():IsAdmin() then return end

	local tbl = net.ReadTable()
	local ent = net.ReadFloat()
	local buttons = {}
	for k, v in pairs(tbl) do
		table.insert(buttons, v)
		table.insert(buttons, function()
			Derma_Query("What do you want it to be?", "What type of console do you want it to be?", "Entrance", function()
				net.Start("ix_civil_terminal_request")
					net.WriteFloat(ent)
					net.WriteString(v)
					net.WriteBool(true)
				net.SendToServer()
			end,
			"Exit", function()
				net.Start("ix_civil_terminal_request")
					net.WriteFloat(ent)
					net.WriteString(v)
					net.WriteBool(false)
				net.SendToServer()
			end)
		end)
	end
	table.insert(buttons, "Cancel")
	table.insert(buttons, function() end)

	DermaQueryCustom("Setup Civil Terminal block", "Please put here the terminal block", unpack(buttons))
end)
