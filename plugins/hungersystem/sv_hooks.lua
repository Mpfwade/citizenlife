local PLUGIN = PLUGIN

function PLUGIN:PlayerSpawn(ply)
    if ply:IsValid() and ply:GetCharacter() then
        ply.ixHungerTick = CurTime() + ix.config.Get("hungerTime", 120)
        ply:GetCharacter():SetHunger(100)
        ply:GetCharacter():SetData("Water", false)
    end
end

local factionIgnore = {
    [FACTION_OTA] = true,
}

function PLUGIN:PlayerTick(ply)
    if ply:IsValid() and ply:GetCharacter() then
        if not ply.ixHungerTick or ply.ixHungerTick <= CurTime() then
            if factionIgnore[ply:Team()] then return false end
            if ply:GetMoveType() == MOVETYPE_NOCLIP then return false end

            local char = ply:GetCharacter()

            if char:GetHunger() == 0 then
                ply:TakeDamage(8)
                ply:EmitSound("citizensounds/puking.wav")
                ply:ChatNotify("I'm dying of starvation!")

                ply.ixHungerTick = CurTime() + 60
                return false
            end

            local newHunger = math.Clamp(char:GetHunger() - 1, 0, 100)
            char:SetHunger(newHunger)

            ply.ixHungerTick = CurTime() + ix.config.Get("hungerTime", 120)

            if newHunger <= 35 and newHunger >= 15 then
                if ply.ixLastHungerPrint == nil or CurTime() > ply.ixLastHungerPrint + 155 then
                    ply:ChatNotify("I need something to eat or drink soon...")
                    ply.ixLastHungerPrint = CurTime()
                end
            elseif newHunger <= 15 then
                if ply.ixLastHungerPrint == nil or CurTime() > ply.ixLastHungerPrint + 155 then
                    ply:ChatNotify("I should really eat or drink something...!")
                    ply.ixLastHungerPrint = CurTime()
                end
            end
        end
    end
end

function PLUGIN:PlayerDeath(client)
    client:RemoveDrunkEffect()
end

function PLUGIN:Think()
    for _, ply in ipairs(player.GetAll()) do
        if ply:GetCharacter() ~= nil and CurTime() >= ply:GetCharacter():GetDrunkEffectTime() and ply:GetCharacter():GetDrunkEffect() > 0 then
            ply:RemoveDrunkEffect()
        end
    end
end
