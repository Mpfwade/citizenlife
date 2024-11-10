ITEM.name = "Shackle Unlocker"
ITEM.description = "A device that unlocks shackles from Vortigaunts."
ITEM.model = "models/props_c17/TrapPropeller_Lever.mdl"
ITEM.category = "Tools"
ITEM.width = 1
ITEM.height = 1

-- Adding a function to use the item from the inventory
ITEM.functions = ITEM.functions or {}
ITEM.functions.Use = {
    name = "Use",
    tip = "useTip",
    icon = "icon16/wrench.png",  -- Icon used in the inventory
    OnRun = function(item)
        local ply = item.player
        local target = ply:GetEyeTrace().Entity

        -- Check if the target is valid, a player, and a Vortigaunt
        if not (IsValid(target) and target:IsPlayer() and target:IsVortigaunt()) then
            ply:Notify("You can only use this on a Vortigaunt.")
            return false
        end

        local char = target:GetCharacter()

        -- Check if the Vortigaunt is already unshackled by looking at the bodygroups or equipment
        if char and char:GetClass() == CLASS_VORT_SHACKLED then
            if target:GetBodygroup(7) == 0 and target:GetBodygroup(8) == 0 and target:GetBodygroup(9) == 0 and target:HasWeapon("ix_vort_beam") then
                ply:Notify("This Vortigaunt has already been unshackled.")
                return false
            end

            -- Remove shackles
            target:SetBodygroup(7, 0)
            target:SetBodygroup(8, 0)
            target:SetBodygroup(9, 0)
            target:Give("ix_vort_beam")
            target:EmitSound("weapons/smg1/smg1_reload.wav")  -- Play a reload sound effect
            target:SelectWeapon("ix_vort_beam")
            target:SetupHands()

            -- Spawn the prop in front of the Vortigaunt
            local spawnPos = target:GetPos() + target:GetForward() * 50 + Vector(0, 0, 10)
            local spawnedProp = ents.Create("prop_physics")
            if IsValid(spawnedProp) then
                spawnedProp:SetModel("models/props_junk/MetalBucket01a.mdl")
                spawnedProp:SetPos(spawnPos)
                spawnedProp:Spawn()
                spawnedProp:Activate()
            end

            -- Create spark effect at the target's position
            local effectData = EffectData()
            effectData:SetOrigin(target:GetPos() + Vector(0, 0, 50))  -- Adjust position for better visibility
            effectData:SetMagnitude(2)  -- Intensity of the sparks
            effectData:SetScale(1)  -- Size of the sparks
            effectData:SetRadius(5)  -- Area affected by the sparks
            util.Effect("cball_explode", effectData, true, true)

            -- Mark the item as used
            item:SetData("used", true)

            -- Notify both the target and the player
            target:Notify("You have been unshackled.")
            ply:Notify("You have successfully unshackled the Vortigaunt.")

            -- If the item should be consumed after use
            return true
        else
            ply:Notify("This Vortigaunt is not shackled.")
            return false
        end
    end,
    OnCanRun = function(item)
        -- Ensure the item is not in the world and can be used from the inventory
        return not IsValid(item.entity)
    end
}

-- If the item is consumed after use, include this function.
function ITEM:OnAfterUse(ply)
    ply:Notify("The shackle unlocker has been used.")
end
