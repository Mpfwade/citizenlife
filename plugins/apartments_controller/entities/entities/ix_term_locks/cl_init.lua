include("shared.lua")

local glowMaterial = Material("sprites/glow04_noz")
local color_orange = Color(255, 125, 0)
local color_green = Color(0, 255, 0)
local color_red = Color(255, 0, 0)

local function LerpColor(tr, tg, tb, from, to)
	tg = tg || tr
	tb = tb || tr
	return Color(Lerp(tr, from.r, to.r),Lerp(tg, from.g, to.g),Lerp(tb, from.b, to.b))
end

function ENT:Draw()
	self:DrawModel()

	local position = self:GetPos() + self:GetUp() * -8.7 + self:GetForward() * -3.85 + self:GetRight() * -6

--	local smokeChargeTime = self:GetActiveSmokeCharge() or 0

	-- local curTime = CurTime()
	-- if (smokeChargeTime and smokeChargeTime > curTime) then
	-- 	local glowColor = Color(255, 0, 0)
	-- 	local timeLeft = smokeChargeTime - curTime

	-- 	if (!self.nextFlash or curTime >= self.nextFlash or (self.flashUntil and self.flashUntil > curTime)) then
	-- 		render.SetMaterial(glowMaterial)
	-- 		render.DrawSprite(position, 14, 14, glowColor)

	-- 		if (!self.flashUntil or curTime >= self.flashUntil) then
	-- 			self.nextFlash = curTime + (timeLeft / 4)
	-- 			self.flashUntil = curTime + (FrameTime() * 4)

	-- 			self:EmitSound("hl1/fvox/beep.wav")
	-- 		end
	-- 	end
	-- elseif (!self:GetDisabledUntil() or CurTime() > self:GetDisabledUntil()) and !self:GetCracked() then
		local color = self:GetLocked() and color_orange or color_green
		local size = 14

		local vel = FrameTime() * 8
		if (self:GetErroring()) then
			color = color_red
			size = 28
			self.color = color
		elseif (self:GetDetonating()) then
			return
		else
			self.color = LerpColor(vel, vel, vel, self.color or color, color)
		end

		render.SetMaterial(glowMaterial)
		render.DrawSprite(position, size, size, self.color)
	-- end
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

net.Receive("ix_civil_terminal_lock_request", function(len, ply)
	if not LocalPlayer():IsAdmin() then return end

	local tbl = net.ReadTable()
	local ent = net.ReadFloat()
	local buttons = {}
	for k, v in pairs(tbl) do
		table.insert(buttons, v)
		table.insert(buttons, function()
			net.Start("ix_civil_terminal_lock_request")
				net.WriteFloat(ent)
				net.WriteString(v)
			net.SendToServer()
		end)
	end
	table.insert(buttons, "Cancel")
	table.insert(buttons, function() end)

	DermaQueryCustom("Setup Civil Terminal block", "Please put here the terminal block", unpack(buttons))
end)
