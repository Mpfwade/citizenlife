local PLUGIN = PLUGIN

PLUGIN.name = "Rank Point System"
PLUGIN.author = "Wade"
PLUGIN.description = "Gives you Rank Points for doing stuff for the combine."

-- old thing, idk why i made tables for this, i guess for config? Gonna redo it in the future.
PLUGIN.rpSystem = PLUGIN.rpSystem or {}

ix.util.Include("sv_plugin.lua")

local PLAYER = FindMetaTable("Player")

function PLAYER:GetRP()
	return self:GetNWInt("ixRP") or ( SERVER and self:GetPData("ixRP", 0) or 0 )
end

do
	local cmd = {}

	cmd.description = "Get a player's rank points"
	cmd.arguments = {ix.type.player}
	cmd.argumentNames = {"Player"}
	cmd.superAdminOnly = true

	function cmd:OnRun(ply, target)
		ply:ChatNotify(target:Nick() .. " has an rp count of " .. target:GetRP())
	end

	ix.command.Add("GetRP", cmd)
end
