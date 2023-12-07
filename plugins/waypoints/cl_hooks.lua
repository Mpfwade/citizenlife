
local PLUGIN = PLUGIN

PLUGIN.waypoints = {}

function PLUGIN:HUDPaint()
	local height = draw.GetFontHeight("RadioFont")
	local clientPos = LocalPlayer():EyePos()

	for index, waypoint in pairs(self.waypoints) do
		if (waypoint.time < CurTime()) then
			self.waypoints[index] = nil

			continue
		end

		local screenPos = waypoint.pos:ToScreen()
		local color = waypoint.color
		local text = waypoint.text
		local x, y = screenPos.x, screenPos.y

		surface.SetMaterial(ix.util.GetMaterial("willardnetworks/tabmenu/skills/skillicons/guns.png"))
		surface.SetDrawColor(color)
		surface.DrawTexturedRect(x - 22, y - 15, 40, 40)

		surface.SetFont("RadioFont")
		surface.SetTextColor(color)
		local width = surface.GetTextSize(text)
		surface.SetTextPos(x - width / 2, y + 25)
		surface.DrawText(text)

		if (!waypoint.noDistance) then
			local distanceText = tostring(math.Round(clientPos:Distance(waypoint.pos) * 0.01905, 2)).."m"
			width = surface.GetTextSize(distanceText)
			surface.SetTextPos(x - width / 2, y - (15 + height))
			surface.DrawText(distanceText)
		end
	end
end

net.Receive("SetupWaypoints", function()
	local bWaypoints = net.ReadBool()

	if (!bWaypoints) then
		PLUGIN.waypoints = {}

		return
	end

	local data = net.ReadTable()

	for index, waypoint in pairs(data) do
		local text = waypoint.text

		-- check for any phrases and replace the text
		if (text:sub(1, 1) == "@") then
			waypoint.text = "<:: "..L(text:sub(2), unpack(waypoint.arguments)).." ::>"
		else
			waypoint.text = "<:: "..text.." ::>"
		end

		data[index] = waypoint
	end

	PLUGIN.waypoints = data
end)

net.Receive("UpdateWaypoint", function()
	local data = net.ReadTable()

	if (data[2] != nil) then
		local text = data[2].text

		-- check for any phrases and replace the text
		if (text:sub(1, 1) == "@") then
			data[2].text = "<:: "..L(text:sub(2), unpack(data[2].arguments)).." ::>"
		else
		    data[2].text = "<:: "..text.." ::>"
		end
	end

	PLUGIN.waypoints[data[1]] = data[2]
end)
