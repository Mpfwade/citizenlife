include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_combine/combine_smallmonitor001.mdl")
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetNetVar("alarm", false)
end

function ENT:Use(ply)
    local combineAvailable
    local inUse

    for _, player in ipairs(player.GetAll()) do
        if player:IsCombine() then
            combineAvailable = true
            break
        end
    end

    combineAvailable = true
    inUse = false

    if combineAvailable then
        if not (ply:IsCombine() or inUse) then
            local card = ply:GetCharacter():GetInventory():HasItem("cid")
            local id = Schema:ZeroNumber(math.random(1, 99999), 5)

            if card then
                local cid = card:GetData("cid", id)
                local area = ply:GetArea()

                if not area or area == "" then
                    area = "Unknown Location"
                end

                self:SetNetVar("alarm", true)
                self:SetNetVar("requester", ply:Nick())

                local sounds = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/attention.wav", "npc/overwatch/radiovoice/alarms62.wav", "npc/overwatch/radiovoice/inprogress.wav", "npc/overwatch/radiovoice/respond.wav", "npc/overwatch/radiovoice/off2.wav"}

                for k, v in ipairs(player.GetAll()) do
                    if v:IsCombine() then
                        ix.util.EmitQueuedSounds(v, sounds, 0, 0.1, 100)
                    end
                end

                -- Waypoint support.
                local waypointPlugin = ix.plugin.Get("waypoints")

                if waypointPlugin then
                    local waypoint = {
                        pos = self:GetPos(),
                        text = "62 ALARMS",
                        color = Color(175, 125, 100),
                        addedBy = ply,
                        time = CurTime() + 300
                    }

                    self:SetNetVar("waypoint", #waypointPlugin.waypoints) -- Save the waypoint index for easy access later.
                    waypointPlugin:AddWaypoint(waypoint)
                    inUse = true
                end
            end
        elseif ply:IsCombine() then
            if self:GetNetVar("alarm", false) then
                self:SetNetVar("alarm", false)
                self:SetNetVar("requester", nil)
                local waypointIndex = self:GetNetVar("waypoint")

                if waypointIndex then
                    local waypointPlugin = ix.plugin.Get("waypoints")

                    if waypointPlugin then
                        waypointPlugin:UpdateWaypoint(waypointIndex, nil)
                    end

                    self:SetNetVar("waypoint", nil)
                    inUse = false
                end

                self:EmitSound("buttons/button14.wav") -- Sound to indicate alarm turned off by Combine.
            else
                self:EmitSound("buttons/button11.wav") -- Sound to indicate alarm is already off.
            end
        else
            ply:ChatPrint("You need a Citizen ID to use the Plea Terminal!")
        end
    elseif self:GetNetVar("alarm", false) then
        self:SetNetVar("alarm", false)
        self:SetNetVar("requester", nil)
        local waypointIndex = self:GetNetVar("waypoint")

        if waypointIndex then
            local waypointPlugin = ix.plugin.Get("waypoints")

            if waypointPlugin then
                waypointPlugin:UpdateWaypoint(waypointIndex, nil)
            end

            self:SetNetVar("waypoint", nil)
            inUse = false
        end
    else
        ply:Notify("There are no officers available at this time!")
    end
end


function ENT:Think()
    if (self.NextAlert or 0) <= CurTime() and self:GetNetVar("alarm") then
        self.NextAlert = CurTime() + 3
        self:EmitSound("ambient/alarms/klaxon1.wav", 80, 50)
        self:EmitSound("ambient/alarms/klaxon1.wav", 80, 50)
        self:SetNetVar("alarmLights", true)

        timer.Simple(2, function()
            self:SetNetVar("alarmLights", false)
        end)
    end

    self:NextThink(CurTime() + 2)
end