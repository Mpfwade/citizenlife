AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "Combine Dispenser"
ENT.Author = "Wade"
ENT.Category = "IX:HL2RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true

if SERVER then
    function ENT:SetupDataTables()
        self:NetworkVar("Bool", 0, "Locked")
        self:NetworkVar("Float", 0, "NextWeaponTime")
    end

    function ENT:Initialize()
        self:SetModel("models/props_junk/watermelon01.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetNoDraw(true)

        self.edispenser = ents.Create("prop_dynamic")
        self.edispenser:DrawShadow(false)
        self.edispenser:SetAngles(self:GetAngles())
        self.edispenser:SetParent(self)
        self.edispenser:SetModel("models/props_combine/combine_dispenser.mdl")
        self.edispenser:SetPos(self:GetPos())
        self.edispenser:Spawn()

        self:DeleteOnRemove(self.edispenser)

        local minimum = Vector(-8, -8, -8)
        local maximum = Vector(8, 8, 64)

        self:SetCollisionBounds(minimum, maximum)
        self:SetCollisionGroup(COLLISION_GROUP_WORLD)
        self:PhysicsInitBox(minimum, maximum)
        self:DrawShadow(false)
    end

    function ENT:Lock()
        self:SetLocked(true)
    end

    function ENT:Unlock()
        self:SetLocked(false)
    end

    playerSelectedWeapons = playerSelectedWeapons or {}

    function ENT:Use(activator, caller)
        if not self:GetLocked() and IsValid(activator) and activator:IsPlayer() then
            local steamID = activator:SteamID()
            local selectedWeapons = playerSelectedWeapons[steamID]
            local edispenser = self.edispenser

            if selectedWeapons and #selectedWeapons > 0 then
                for _, weaponName in ipairs(selectedWeapons) do
                    local spawnPos = self:GetPos() + self:GetUp() * -5 
                    edispenser:Fire("SetAnimation", "dispense_package", 0)

                    timer.Simple(1, function()
                        ix.item.Spawn(weaponName, spawnPos)
                    end)
                end
                playerSelectedWeapons[steamID] = nil 
                self:EmitSound("ambient/machines/combine_terminal_idle4.wav")
            else
                return false
            end
        end
    end    

    util.AddNetworkString("SelectWeapon")
    util.AddNetworkString("DisplayError")

    net.Receive("SelectWeapon", function(len, client)
        local weaponName = net.ReadString()
        local char = client:GetCharacter()
        if not char then return end
    
        local inventory = char:GetInventory()
        if inventory:HasItem(weaponName) then
            net.Start("DisplayError")
            net.WriteString("You already have this weapon.")
            net.Send(client)
            return
        end

        local allowedWeapons = {
            [CLASS_CCA_BASICUNIT] = {"stunstick", "usp"},
            [CLASS_CCA_GROUNDUNIT] = {"stunstick", "usp", "smg"},
            [CLASS_CCA_RL] = {"stunstick", "usp", "smg", "manhack"}
            -- ... other classes and weapons ...
        }
    
        local class = char:GetClass()
        local classAllowedWeapons = allowedWeapons[class]
        local steamID = client:SteamID()
    
        if classAllowedWeapons and table.HasValue(classAllowedWeapons, weaponName) then
            if not playerSelectedWeapons[steamID] then
                playerSelectedWeapons[steamID] = {}
            end
    
            if table.HasValue(playerSelectedWeapons[steamID], weaponName) then
                net.Start("DisplayError")
                net.WriteString("You have already selected this weapon.")
                net.Send(client)
            else
                table.insert(playerSelectedWeapons[steamID], weaponName)
            end
        else
            client:ChatPrint('The Dispenser states, "<:: Current rank does not permit distribution of this verdict ::>"')
        end
    end)
end

if CLIENT then
    local glowMaterial = Material("sprites/glow04_noz")
    function ENT:Draw()
        self:DrawModel()
        local _, _, _, a = self:GetColor()
        local glowColor = Color(0, 0, 255, a)
        local position = self:GetPos() + self:GetForward() * 10 + self:GetRight() * -1.5 + self:GetUp() * 22
        render.SetMaterial(glowMaterial)
        render.DrawSprite(position, 20, 20, glowColor)

        -- Dynamic Light
        local dlight = DynamicLight(self:EntIndex())
        if dlight then
            dlight.pos = position
            dlight.r = 0
            dlight.g = 0
            dlight.b = 255
            dlight.brightness = 2
            dlight.Decay = 0 -- No decay, keep the light constant
            dlight.Size = 256 -- Size of the light
            dlight.DieTime = CurTime() + 0.1 -- Keep refreshing the light
        end
    end
end