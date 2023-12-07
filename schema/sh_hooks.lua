--[[---------------------------------------------------------------------------
	Shared Hooks
---------------------------------------------------------------------------]]
--
function Schema:CanTool(ply, trace, toolname, tool, button)
    if ply and toolname then
        if (toolname == "creator") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "permaall") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "energyball") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "fire") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "glow") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "smoke") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "smoke_trail") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "sparks") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "steam") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "tesla") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "item_ammo_crate") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "prop_door") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "env_headcrabcanister") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "item_item_crate") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "prop_thumper") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "dynamite") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "emitter") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "wheel") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "light") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "lamps") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "thruster") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "hover") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "hoverball") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "balloons") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "balloon") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "rope") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "winch") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "slider") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "pulley") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "motor") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "muscle") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "paint") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "hydraulic") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        if (toolname == "mmm") and not ply:IsSuperAdmin() then
            ply:Notify("You cannot use this tool.")
            MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " tried to use the ", toolname, " tool.\n")

            return false
        end

        MsgAll(tostring(ply), " ", tostring(ply:SteamID()), " used the ", toolname, " tool.\n")
    end
end

function Schema:CanProperty(ply, property, ent)
    if property == "persist" then
        if SERVER then
            ply:Notify("Persist Feature is disabled, please use perma all tool instead!")
        end

        return false
    end
end

function Schema:PrePACEditorOpen(ply)
    if not (ply:IsSuperAdmin() or ply:IsDonator()) then
        ply:ChatNotify("PAC3 is restricted to certain users only!")

        return false
    end
end

function Schema:CanPlayerJoinClass()
    return false
end

function Schema:CanDrive()
    return false
end

function Schema:OnCharacterCreated(ply, char)
    char:SetData("ixKnownName", char:GetName())

    return true
end

function Schema:EntityTakeDamage(target, dmginfo)
    if target:IsPlayer() then
        if dmginfo:GetAttacker():GetClass() == "npc_headcrab" or dmginfo:GetAttacker():GetClass() == "npc_headcrab_fast" then
            dmginfo:ScaleDamage(math.random(3.00, 5.00))
        end

        if dmginfo:GetDamageType() == DMG_BULLET then
            if not (target:Armor() == 0) then
                dmginfo:ScaleDamage(0.9)
            end
        elseif (dmginfo:GetDamageType() == DMG_CRUSH) and not IsValid(target.ixRagdoll) then
            dmginfo:ScaleDamage(0)
        end
    end
end

function Schema:CanPlayerUseBusiness(ply, uniqueID)
    local itemTable = ix.item.list[uniqueID]

    if itemTable then
        if (ply.ixCWUClass == 3) and (itemTable.category == "Consumeables") or (itemTable.category == "Medical Items") then
            ply.noBusinessAllow = true

            return true
        else
            ply.noBusinessAllow = false

            return false
        end
    end
end

function Schema:CanPlayerViewData(client, target)
    return client:IsCombine() and (not target:IsCombine() and target:Team() ~= FACTION_ADMIN)
end

-- stop with the fucking sparks jeez
function Schema:simfphysPhysicsCollide()
    return true
end