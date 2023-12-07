local PLUGIN = PLUGIN

function PLUGIN:PlayerInitialSpawn(ply)
	ply:SetLP(ply:GetPData("ixLP") or 0)
end

local PLAYER = FindMetaTable("Player")

function PLAYER:SetLP(value)
	if (tonumber(value) < 0) then
		return
	end
	
	self:SetPData("ixLP", tonumber(value))
	self:SetNWInt("ixLP", tonumber(value))
end


concommand.Add("ix_lp_set", function(ply, cmd, args)
	if args[1] and args[2] and ply:IsSuperAdmin() then
		local target = ix.util.FindPlayer(args[1])
		target:SetPData("ixLP", args[2])
		target:SetNWInt("ixLP", args[2])
	end
end)

concommand.Add("ix_lp_get", function(ply, cmd, args)
	if (args[1]) then
		local target = ix.util.FindPlayer(args[1])
		if target and target:IsValid() then
			ply:ChatNotify("==== "..target:SteamName().."'s LP Count ====")
			ply:ChatNotify("LP: "..target:GetLP())
		else
			ply:ChatNotify("Unspecified User, invalid input.")
		end
	else
		ply:ChatNotify("==== YOUR LP Count ====")
		ply:ChatNotify("LP: "..ply:GetLP())
	end
end)