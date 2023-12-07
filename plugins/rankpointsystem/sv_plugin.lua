local PLUGIN = PLUGIN

function PLUGIN:PlayerInitialSpawn(ply)
    ply:SetRP(ply:GetPData("ixRP") or 0)
end

local PLAYER = FindMetaTable("Player")

function PLAYER:SetRP(value)
    if tonumber(value) < 0 then return end
    self:SetPData("ixRP", tonumber(value))
    self:SetNWInt("ixRP", tonumber(value))
end

concommand.Add("ix_rp_set", function(ply, cmd, args)
    if args[1] and args[2] and ply:IsSuperAdmin() then
        local target = ix.util.FindPlayer(args[1])
        target:SetPData("ixRP", args[2])
        target:SetNWInt("ixRP", args[2])
    end
end)

concommand.Add("ix_rp_get", function(ply, cmd, args)
    if args[1] then
        local target = ix.util.FindPlayer(args[1])

        if target and target:IsValid() then
            ply:ChatNotify("==== " .. target:SteamName() .. "'s Rank Point Count ====")
            ply:ChatNotify("RP: " .. target:GetRP())
        else
            ply:ChatNotify("Unspecified User, invalid input.")
        end
    else
        ply:ChatNotify("==== YOUR RANK POINT COUNT ====")
        ply:ChatNotify("RP: " .. ply:GetRP())
    end
end)

local CitWeapons = {
    ["ls_pistol"] = true,
    ["ls_ar2"] = true,
    ["ls_axe"] = true,
    ["ls_brokenbottle"] = true,
    ["ls_357mag"] = true,
    ["ls_shitbarrelshotgun"] = true,
    ["ls_nailgun"] = true,
    ["ls_shitrevolver"] = true,
    ["ls_shitsemirifle"] = true,
    ["ls_shitpipeshotgun"] = true,
    ["ls_katana"] = true,
    ["ls_pickaxe"] = true,
    ["ls_pipe"] = true,
    ["ls_smg"] = true,
    ["ls_spas12"] = true,
    ["ls_molotov"] = true,
}

hook.Add("DoPlayerDeath", "FactionCCADeath", function(victim, attacker, dmginfo)
    if attacker:IsPlayer() and attacker:Team() == FACTION_CCA and victim:Team() == FACTION_CITIZEN then
        local players = player.GetAll()

        for _, ply in ipairs(players) do
            if ply:Team() == FACTION_CCA and ply:GetPos():Distance(victim:GetPos()) <= 800 then
                local victimWeapon = victim:GetActiveWeapon()

                if IsValid(victimWeapon) and CitWeapons[victimWeapon:GetClass()] then
                    PLUGIN:AddCombineDisplayMessage(string.upper(ply:Nick()).." has gained two rank points for amputation of an anti-citizen...", Color(155,211,221,255))
                    ply:SetRP(2 + ply:GetNWInt("ixRP"))
                else
                    return
                end
            end
        end
    end
end)