local PLUGIN = PLUGIN

PLUGIN.name = "LP System"
PLUGIN.author = "Wade"
PLUGIN.description = "Gives you LP for doing stuff for the combine."

-- old thing, idk why i made tables for this, i guess for config? Gonna redo it in the future.
PLUGIN.lpSystem = PLUGIN.lpSystem or {}

ix.util.Include("sv_plugin.lua")

local PLAYER = FindMetaTable("Player")

function PLAYER:GetLP()
	-- Player's LP might not have loaded so we check PData too
	return self:GetNWInt("ixLP") or ( SERVER and self:GetPData("ixLP", 0) or 0)
end

do
	local cmd = {}

	cmd.description = "Get a player's loyalty points"
	cmd.arguments = {ix.type.player}
	cmd.argumentNames = {"Player"}
	cmd.superAdminOnly = true

	function cmd:OnRun(ply, target)
		ply:ChatNotify(target:Nick() .. " has an lp count of " .. target:GetLP())
	end

	ix.command.Add("GetLP", cmd)
end
