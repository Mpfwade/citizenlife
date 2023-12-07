AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_combine/combine_interface001.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
        phys:EnableMotion(false)
    end
end

function ENT:SpawnFunction(ply, trace)
    local angles = ply:GetAngles()
    local entity = ents.Create("ix_arrest_terminal")
    entity:SetPos(trace.HitPos)
    entity:SetAngles(Angle(0, (entity:GetPos() - ply:GetPos()):Angle().y - 180, 0))
    entity:Spawn()
    entity:Activate()

    return entity
end

function ENT:Think()
    if (self.nextTerminalCheck or 0) < CurTime() then
        self:StopSound("ambient/machines/combine_terminal_loop1.wav")
        self:EmitSound("ambient/machines/combine_terminal_loop1.wav", 50)
        self.nextTerminalCheck = CurTime() + 10
    end
end

function ENT:OnRemove()
    self:StopSound("ambient/machines/combine_terminal_loop1.wav")
end

function ENT:Use(ply)
    if (self.useCooldown or 0) < CurTime() then
        if (not ply:GetCharacter()) or (not ply:IsCombine()) then
            ply:ChatPrint("You need to be a Combine to use the Combine Terminal!")

            return
        end

        self:EmitSound("ambient/machines/combine_terminal_idle" .. math.random(1, 2) .. ".wav", 60)
        ply:OpenVGUI("LiteNetworkTerminal")
        self.useCooldown = CurTime() + 3
    end
end

util.AddNetworkString("ixCombineTerminalCharge")

net.Receive("ixCombineTerminalCharge", function(len, ply)
    if not (ply:GetCharacter() and ply:IsCombine()) then
        ply:ChatPrint("You need to be a Combine to use the Combine Terminal!")

        return
    end

    local restrictedPlayers = {}
    local radius = 96
    local nearbyPlayers = ents.FindInSphere(ply:GetPos(), radius)

    for _, target in ipairs(nearbyPlayers) do
        if IsValid(target) and target:IsPlayer() and target:IsRestricted() then
            table.insert(restrictedPlayers, target)
        end
    end

    if #restrictedPlayers == 0 then
        ply:Notify("There's nobody that's tied near you!")

        return
    end

    local target = restrictedPlayers[1] -- Change this line to assign the target you desire

    if target.ixJailState then
        ply:Notify("The target is already serving a sentence.")

        return
    end

    local chargesTable = net.ReadTable()
    local chargesMessage = "Attention, you have been charged with: "
    local chargesMessageTable = {}
    local chargesSounds = {}
    local chargesTimeOriginal = net.ReadUInt(4)
    local chargesTime = net.ReadUInt(12)
    table.insert(chargesSounds, "npc/overwatch/radiovoice/attentionyouhavebeenchargedwith.wav")

    for k, v in pairs(chargesTable) do
        local chargeData = ix.combineterminal.charges[v]

        if chargeData then
            table.insert(chargesMessageTable, chargeData.name)
            table.insert(chargesSounds, chargeData.sound)
        else
            ply:Notify("Invalid charge.")

            return
        end
    end

    table.insert(chargesSounds, "npc/overwatch/radiovoice/youarejudgedguilty.wav")
    local chargesMessageTableString = table.concat(chargesMessageTable, "; ")
    chargesMessage = chargesMessage .. chargesMessageTableString .. ". You are judged guilty by the Civil Protection team."
    ix.chat.Send(ply, "dispatchperson", chargesMessage, false)
    ix.util.EmitQueuedSounds(ply, chargesSounds)
    local targetCharacter = target:GetCharacter()
    ply:ChatNotify("Target: " .. target:Nick())
    ply:ChatNotify("Sentenced Time: " .. chargesTime)
    target:ChatNotify("You have been sentenced for " .. chargesTime .. " seconds!")
    target:StripWeapons()

    if target:Team() == FACTION_CITIZEN then
        target:SetBodygroup(1, 28)
    end

    target.ixJailState = true

    if target:GetNWBool("ixActiveBOL", true) then
        target:SetNWBool("ixActiveBOL", false)
        ply:SetRP(1 + ply:GetNWInt("ixRP"))
        ply:ChatNotify("You have gained a Rank Point for arresting a BOL target")
    end

    timer.Simple(chargesTime - 5, function()
        if IsValid(target) then
            target:ChatNotify("Your sentence will be taken away in 5 seconds.")
        end
    end)

    timer.Simple(chargesTime, function()
        if IsValid(target) then
            target.ixJailState = nil

            if target:Team() == FACTION_CITIZEN and chargesTime > 239 then
                ix.chat.Send(ply, "dispatchradio", "Attention, " .. target:Nick() .. " has served their time. Amputate them immediately.")
                target:SetBodygroup(1, 0)
                target:SetBodygroup(2, 0)
            elseif target:Team() == FACTION_CITIZEN and chargesTime < 240 then
                ix.chat.Send(ply, "dispatchradio", "Attention, " .. target:Nick() .. " has served their sentence. Release them immediately.")
                target:SetBodygroup(1, 0)
                target:SetBodygroup(2, 0)
            end

            if target:Team() == FACTION_VORTIGAUNT then
                ix.chat.Send(ply, "dispatchradio", "Attention, BIOTIC has served isolation. Release BIOTIC when available.")
            end
        end
    end)
end)