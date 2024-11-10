-- Item Statistics

ITEM.name = "Health Vial"
ITEM.description = "A small vial with green liquid."
ITEM.category = "Medical Items"
ITEM.bDropOnDeath = true
ITEM.weight = 0.45

-- Item Configuration

ITEM.model = "models/healthvial.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

-- Item Custom Configuration

ITEM.HealAmount = 30
ITEM.Volume = 70
ITEM.price = 40

-- Item Functions

ITEM.functions.Apply = {
    name = "Heal yourself",
    icon = "icon16/heart.png",
    OnCanRun = function(itemTable)
        local ply = itemTable.player
        if not IsValid(ply) then return false end
        local char = ply:GetCharacter()
        return char and (ply:Health() < ply:GetMaxHealth() or char:GetData("sickness", 0) > 0)
    end,
    OnRun = function(itemTable)
        local ply = itemTable.player
        local char = ply:GetCharacter()
        if not IsValid(ply) or not char then return false end

        ply:SetAction("Applying " .. itemTable.name .. "...", 3, function()
            ply:SetHealth(math.min(ply:Health() + itemTable.HealAmount, ply:GetMaxHealth()))
            ply:EmitSound("items/smallmedkit1.wav", itemTable.Volume)

            if char:GetHunger() > 85 then
                char:SetData("sickness", 0)
                char:SetData("sickness_immunity", true)
                char:SetData("sicknessType", "none")
            end

            timer.Simple(600, function()
                if IsValid(char) then
                    char:SetData("sickness_immunity", nil)
                end
            end)

            ply:Notify("You applied a " .. itemTable.name .. " on yourself and you have gained health.")
            ply:SetNWBool("Healed", true)
            if ply:GetNWBool("Dying", true) == true then
                ply:SetNWBool("Dying", false)
                ply:StopSound("player/heartbeat1.wav")
            end

            return true
        end)
    end,
}

ITEM.functions.ApplyTarget = {
    name = "Heal target",
    icon = "icon16/heart_add.png",
    OnCanRun = function(itemTable)
        local ply = itemTable.player
        if not IsValid(ply) then return false end
        local data = {
            start = ply:GetShootPos(),
            endpos = ply:GetShootPos() + ply:GetAimVector() * 96,
            filter = ply
        }
        local target = util.TraceLine(data).Entity
        if not IsValid(target) or not target:IsPlayer() then return false end
        local targetChar = target:GetCharacter()
        return targetChar and (target:Health() < target:GetMaxHealth() or targetChar:GetData("sickness", 0) > 0)
    end,
    OnRun = function(itemTable)
        local ply = itemTable.player
        if not IsValid(ply) then return false end
        local data = {
            start = ply:GetShootPos(),
            endpos = ply:GetShootPos() + ply:GetAimVector() * 96,
            filter = ply
        }
        local target = util.TraceLine(data).Entity
        if IsValid(target) and target:IsPlayer() then
            local targetChar = target:GetCharacter()
            if targetChar then
                ply:SetAction("Applying " .. itemTable.name .. "...", 3, function()
                    ply:ForceSequence("Heal", nil, nil, true)
                    target:SetHealth(math.min(target:Health() + itemTable.HealAmount, target:GetMaxHealth()))
                    ply:EmitSound("items/smallmedkit1.wav", itemTable.Volume)
                    target:EmitSound("items/smallmedkit1.wav", itemTable.Volume)

                    if targetChar:GetHunger() > 85 then
                        targetChar:SetData("sickness", 0)
                        targetChar:SetData("sickness_immunity", true)
                        targetChar:SetData("sicknessType", "none")
                    end

                    timer.Simple(600, function()
                        if IsValid(targetChar) then
                            targetChar:SetData("sickness_immunity", nil)
                        end
                    end)

                    ply:Notify("You applied a " .. itemTable.name .. " on yourself and you have gained health.")
                    target:Notify(ply:Nick() .. " applied a " .. itemTable.name .. " on you and you have gained health.")
                    target:SetNWBool("Healed", true)
                    if target:GetNWBool("Dying", true) == true then
                        target:SetNWBool("Dying", false)
                        target:StopSound("player/heartbeat1.wav")
                    end

                    ply:LeaveSequence()
                    return true
                end)
                return true
            end
        end
        return false
    end
}
