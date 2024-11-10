local PLUGIN = PLUGIN
PLUGIN.name = "Combine Facial Recognition"
PLUGIN.author = "Elec / ZeMysticalTaco"
PLUGIN.description = "Facial Recognition for Clockwork, adapted for use on HELIX and CMRP, thanks for the code, Elec!"
ix.option.Add("Combine Recognition", ix.type.bool, true)

hook.Add("PlayerSpawn", "ixSetDivision", function(ply)
	if ply:GetChar() then
		ply:SetNetVar("mpfdivision", ply:GetChar():GetData("mpfdivision", ""))
	end
end)

if CLIENT then
	-- hud
	local alphas = {}
	local sizes = {}
	local str_lens = {}

	local function MatrixText(text, font, x, y, color, scale, rotation)
		surface.SetFont(font)
		local matrix = Matrix()
		matrix:Translate(Vector(x, y, 1))
		matrix:Scale(scale or Vector(1, 1, 1))
		matrix:Rotate(rotation or Angle(0, 0, 0))
		cam.PushModelMatrix(matrix)
		surface.SetTextPos(0, 0)
		surface.SetTextColor(color.r, color.g, color.b, color.a)
		surface.DrawText(text)
		cam.PopModelMatrix()
	end

	surface.CreateFont("FaceDick", {
		font = "Eurostile",
		size = 100,
		antialias = true,
	    shadow = false,
		scanlines = 10,
	    blursize = 1,
	})

	function PLUGIN:HUDPaint()
		if LocalPlayer():Team() ~= FACTION_CCA then
			return
		end

		for k, v in pairs(player.GetAll()) do
			-- we can't see the faces of MPF/OTA
			-- this aint facial recognition anymore ELEC BOYE
			if v ~= LocalPlayer() and v:GetMoveType() ~= MOVETYPE_NOCLIP and v:IsCombine() then
				--if table.HasValue(no_recog_models, v:GetModel()) then return end
				if not alphas[v:EntIndex()] then
					alphas[v:EntIndex()] = 0
				end

				if not sizes[v:EntIndex()] then
					sizes[v:EntIndex()] = 100
				end

				if not str_lens[v:EntIndex()] then
					str_lens[v:EntIndex()] = 0
				end

				local head = v:LookupBone("ValveBiped.Bip01_Head1")
				local headpos
				local headposP

				if head then
					headposP = v:GetBonePosition(head)
					headpos = v:GetBonePosition(head):ToScreen()
				else
					headposP = v:EyePos()
					headpos = v:EyePos():ToScreen()
				end

				-- scale stuff properly with distance
				local size = sizes[v:EntIndex()]
				local scale = v:GetPos():Distance(LocalPlayer():GetPos()) / 250
				size = size / scale
				local name = v:Name()
				surface.SetFont("FaceDick")
				local ns_x, ns_y = surface.GetTextSize(name)
				local range = 512
				local recog_on = ix.option.Get("Combine Recognition")

				-- check if the player is in range, that their face is visible and that they're alive. and, of course, if facial recog is turned on.
				local tr = util.TraceLine({
					start = EyePos(),
					endpos = headposP,
					mask = MASK_VISIBLE_AND_NPCS,
					filter = {LocalPlayer(), v}
				})

				if v:GetPos():Distance(LocalPlayer():GetPos()) <= range and v:Alive() and recog_on and not tr.Hit then
					-- if yes, make magic with alphas, sizes, etc.
					alphas[v:EntIndex()] = Lerp(FrameTime() * 5, alphas[v:EntIndex()], 255)
					sizes[v:EntIndex()] = Lerp(FrameTime() * 5, sizes[v:EntIndex()], 20)
					local str_len_mul = 6

					if sizes[v:EntIndex()] < 40 then
						str_len_mul = 50
					end

					str_lens[v:EntIndex()] = Lerp(FrameTime() * str_len_mul, str_lens[v:EntIndex()], ns_x)
				else
					alphas[v:EntIndex()] = Lerp(FrameTime() * 10, alphas[v:EntIndex()], 0)
					sizes[v:EntIndex()] = Lerp(FrameTime() * 10, sizes[v:EntIndex()], 80)
					str_lens[v:EntIndex()] = Lerp(FrameTime() * 10, str_lens[v:EntIndex()], 0)
				end

				--[[and v:GetAimVector():Dot(LocalPlayer():GetAimVector()) < 0--]]
				-- draw the box/line
				surface.SetDrawColor(255, 255, 255, alphas[v:EntIndex()])
				local team_color = team.GetColor(v:Team())
				local name_size = 0.075				--[[-------------------------------------------------------------------------
			If we ever go to ALL CAPS ranks i'll kill myself.
			---------------------------------------------------------------------------]]
				--local rank = string.match(v:Name(), "%p%a%a%a%p") or string.match(v:Name(), "%p%d%d%p") or "CANNOT PARSE RANK

				--if string.find(v:Name(), "OTA") or string.find(v:Name(), "USF:D") then
				--	rank = string.match(v:Name(), "%p%a%a%a%p")
				local ota = string.find(v:Name(), "OTA")
				local airw = string.find(v:Name(), "SCN")
				local cca = string.find(v:Name(), "CCA")
				assessment = ix.config.Get("code_mpf")
				local squad = v:GetSquad() or "NONE"

				-- draw text
				if v:IsCombine() then
					if v:Team() == FACTION_CCA then
						MatrixText("<:: UNIT: " .. string.upper(v:Nick()) .. " //", "FaceDick", headpos.x + size / 1.9, headpos.y - size * 0.9, Color(team_color.r, team_color.g, team_color.b, alphas[v:EntIndex()]), Vector(name_size / scale, name_size / scale, 1))
						MatrixText("ASSESSMENT: PROTECT, SERVE ::>", "FaceDick", headpos.x + size / 1.9, headpos.y - size / 4, Color(255, 255, 255, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
						MatrixText("PATROL TEAM: " .. squad, "FaceDick", headpos.x + size / 1.9, headpos.y - size * 0.5, Color(team_color.r - 50, team_color.g - 50, team_color.b - 50, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))

					elseif v:Team() == FACTION_OTA then
							MatrixText("<:: SOLIDER: " .. string.upper(v:Nick()) .. " ::>", "FaceDick", headpos.x + size / 1.9, headpos.y - size * 0.9, Color(team_color.r, team_color.g, team_color.b, alphas[v:EntIndex()]), Vector(name_size / scale, name_size / scale, 1))
							MatrixText("ASSESSMENT: CONTAIN, SACRIFICE", "FaceDick", headpos.x + size / 1.9, headpos.y - size / 4, Color(255, 255, 255, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
							MatrixText("SQUAD TEAM: " .. squad, "FaceDick", headpos.x + size / 1.9, headpos.y - size * 1.1, Color(team_color.r - 50, team_color.g - 50, team_color.b - 50, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))

						if v:IsSquadLeader() then
							MatrixText("PATROL LEADER", "FaceDick", headpos.x + size / 1.9, headpos.y - size * 1.6, Color(220, 255, 100, 255), Vector(0.05 / scale, 0.05 / scale, 1))
						end

						if ota then
							MatrixText("OVERWATCH SOLDIER", "FaceDick", headpos.x + size / 1.9, headpos.y - size * 1.3, Color(200, 0, 0, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
						elseif airw then
							MatrixText("AIRWATCH UNIT", "FaceDick", headpos.x + size / 1.9, headpos.y - size * 1.3, Color(180, 50, 100, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
						elseif cca then
							MatrixText("PROTECTION UNIT", "FaceDick", headpos.x + size / 1.9, headpos.y - size * 1.3, Color(10, 50, 100, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
						end

						if v:GetNetVar("squad", "none") == LocalPlayer():GetNetVar("squad", "") then
							MatrixText("PT ASSET", "FaceDick", headpos.x + size / 1.9, headpos.y - size / 16 + 16, Color(255, 255, 255, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
						end
					end
				end

				local line_matrix = Matrix()
				cam.PushModelMatrix(line_matrix)
				surface.DrawOutlinedRect(0, 0, str_lens[v:EntIndex()], 1)
				cam.PopModelMatrix()
			end
		end
	end
end
