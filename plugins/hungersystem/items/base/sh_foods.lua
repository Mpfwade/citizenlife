ITEM.name = "Consumable Base"
ITEM.model = Model("models/props_junk/garbage_takeoutcarton001a.mdl")
ITEM.description = "A base for consumables."
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Consumables"
ITEM.noBusiness = true
ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav"
ITEM.useName = "Consume"
ITEM.RestoreHunger = 0
ITEM.RestoreHealth = 0
ITEM.damage = 0
ITEM.spoilTime = 14
ITEM.effectAmount = 0.2
ITEM.effectTime = 1
ITEM.returnItems = {}

function ITEM:GetName()
    if self:GetSpoiled() then
        local spoilText = self.spoilText or "Spoiled"

        return spoilText .. " " .. self.name
    end

    return self.name
end

function ITEM:GetDescription()
    local description = {self.description}

    if not self:GetSpoiled() and self:GetData("spoilTime") then
        local spoilTime = math.floor((self:GetData("spoilTime") - os.time()) / 60)
        local text = " minutes."

        if spoilTime > 60 then
            text = " hours."
            spoilTime = math.floor(spoilTime / 60)
        end

        if spoilTime > 24 then
            text = " days."
            spoilTime = math.floor(spoilTime / 24)
        end

        description[#description + 1] = "\nSpoils in " .. spoilTime .. text
    end

    return table.concat(description, "")
end

function ITEM:GetSpoiled()
    local spoilTime = self:GetData("spoilTime")
    if not spoilTime then return false end

    return os.time() > spoilTime
end

function ITEM:OnInstanced()
    if self.spoil then
        self:SetData("spoilTime", os.time() + 24 * 60 * 60 * self.spoilTime)
    end
end

ITEM.functions.Consume = {
    icon = "icon16/user.png",
    name = "Consume",
    OnRun = function(item)
        local ply = item.player
        local character = item.player:GetCharacter()
        local bSpoiled = item:GetSpoiled()
        local actiontext = "Invalid Action"

        if ply.isConsumingConsumeable == true then
            ply:ChatNotify("I can't stuff too much food down my mouth.")

            return false
        end

        if item.useSound then
            if string.find(item.useSound, "drink") or (item.category == "Drinkable") then
                actiontext = "Drinking.."
            else
                actiontext = "Consuming.."
            end
        end

        if item.category == "Drinkable" then
            if istable(item.returnItems) then
                for _, v in ipairs(item.returnItems) do
                    character:GetInventory():Add(v)
                end
            else
                character:GetInventory():Add(item.returnItems)
            end

            ply:AddDrunkEffect(item.effectAmount, item.effectTime)
        end
        
        if item.name == "Water Can" then
            if not character:GetData("Water", false) then
            character:SetData("Water", true)
    
            ply:ViewPunch(Angle(math.Rand(-10, 10), math.Rand(-10, 10), math.Rand(-10, 10)))
    
            timer.Simple(3.5, function()
                ply:ChatNotify("I feel funny...")
            end)
    
            timer.Simple(20, function()
                ply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 1, 1)
                character:SetData("Water", false)
    
                timer.Simple(1.5, function()
                    ply:ConCommand("say \"Where am I? How did I get here?\"")
                end)
            end)
        elseif character:GetData("Water", true) then
            return
        end
    end


        local function EatFunction(ply, character, bSpoiled)
            if not (ply:IsValid() and ply:Alive() and character) then return end

            if item.damage > 0 then
                ply:TakeDamage(item.damage, ply, ply)
            end

            if item.junk then
                if not character:GetInventory():Add(item.junk) then
                    ix.item.Spawn(item.junk, ply)
                end
            end

            if item.useSound then
                if istable(item.useSound) then
                    ply:EmitSound(table.Random(item.useSound))
                else
                    timer.Simple(1.2, function()
                        ply:EmitSound(item.useSound)
                    end)
                end
            end

            if not bSpoiled then
                if item.RestoreHunger > 0 then
                    character:SetHunger(math.Clamp(character:GetHunger() + item.RestoreHunger, 0, 100))
                end

                if item.RestoreHealth > 0 then
                    ply:SetHealth(math.Clamp(ply:Health() + item.RestoreHealth, 0, ply:GetMaxHealth()))
                end
            else
                ply:TakeDamage(math.random(1, 5))
            end

            -- Put the consumed food's model in the player's hand
            if item.model and IsValid(ply) then
                local rightHandBone = ply:LookupBone("ValveBiped.Bip01_R_Finger02")

                if rightHandBone then
                    local model = ents.Create("prop_physics")
                    if not IsValid(model) then return end
                    model:SetModel(item.model)
                    local offset = Vector(0, 0, 0) -- Adjust this offset to position the model correctly
                    model:SetPos(ply:GetPos() + offset)
                    model:SetAngles(Angle(0, 0, 0)) -- Set the angles to match the item's model
                    model:Spawn()
                    model:SetCollisionGroup(COLLISION_GROUP_WEAPON)
                    model:SetSolid(SOLID_NONE)
                    model:SetOwner(ply)
                    -- Freeze the prop in place
                    local phys = model:GetPhysicsObject()

                    if IsValid(phys) then
                        phys:EnableMotion(false)
                    end

                    model:FollowBone(ply, rightHandBone) -- Attach the model to the right hand bone
                    ply:ConCommand("ix_act_FistRight")
                    ply.ix_foodModel = model
                    ply.isConsumingConsumeable = true
                end
            end

            -- Delete the model after 1 second
            timer.Simple(1.3, function()
                if IsValid(ply.ix_foodModel) then
                    ply.ix_foodModel:Remove()
                    ply.isConsumingConsumeable = false
                end
            end)
        end

        if item.useTime then

            ply:SetAction(actiontext, item.useTime, function()
                EatFunction(ply, character, bSpoiled)
            end)
        else
            EatFunction(ply, character, bSpoiled)
        end
    end
}