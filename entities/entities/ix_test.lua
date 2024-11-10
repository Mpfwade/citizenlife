AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Processing Camera"
ENT.Author = "citizenlifedev"
ENT.Category = "IX:HL2RP"
ENT.Spawnable = true
ENT.AdminOnly = true

-- Model for the entity
ENT.Model = "models/props_combine/combine_binocular01.mdl"

-- Table to store detected players' models by character ID
ENT.DetectedPlayerModels = {}

if CLIENT then
    local fadeOut = false
    local alpha = 0
    local fadeInSpeed = 500 * 1.5 -- Keep the fade-in speed fast
    local fadeOutSpeed = 500 * 0.5 -- Slow down the fade-out speed

    -- Function to trigger the white flash effect
    function TriggerPlayerFlash()
        fadeOut = true
        alpha = 0
        hook.Add("HUDPaint", "FadeToWhite", function()
            if fadeOut then
                alpha = math.min(alpha + FrameTime() * fadeInSpeed, 255)
                if alpha >= 255 then
                    fadeOut = false
                end
            else
                alpha = math.max(alpha - FrameTime() * fadeOutSpeed, 0)
                if alpha <= 0 then
                    hook.Remove("HUDPaint", "FadeToWhite")
                end
            end

            surface.SetDrawColor(255, 255, 255, alpha) -- Set color to white
            surface.DrawRect(0, 0, ScrW(), ScrH())
        end)
    end
end

-- Initialize the entity
function ENT:Initialize()
    -- Set the model
    self:SetModel(self.Model)
    
    -- Initialize physics
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    -- Wake the physics object
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end

    -- Initialize detection state
    self.DetectedPlayers = {}
    self.PlayerDetected = false

    -- Initialize cooldown states
    self.NextUseTime = 0 -- Timestamp for when the entity can next be used
    self.NextMessageTime = 0 -- Timestamp for when the cooldown message can next be shown
end

-- Function to check if a player is in front of the camera using multiple trace lines
function ENT:DetectPlayers()
    local startPos = self:GetPos() + self:GetUp() * 20 -- Move the start position further down from the entity's base
    local angles = {-10, -5, 0, 5, 10} -- Angles to trace closer together within a 20-degree spread

    self.DetectedPlayers = {}

    for _, angleOffset in ipairs(angles) do
        local traceDir = self:GetForward():Angle()
        traceDir:RotateAroundAxis(self:GetUp(), angleOffset)
        local endPos = startPos + traceDir:Forward() * 500 -- Adjust the distance as needed

        local trace = util.TraceLine({
            start = startPos,
            endpos = endPos,
            filter = self
        })

        -- Check if the trace hits a player
        if trace.Hit and IsValid(trace.Entity) and trace.Entity:IsPlayer() then
            table.insert(self.DetectedPlayers, trace.Entity)
        end
    end

    -- Update detection state on the server side
    if SERVER then
        self.PlayerDetected = #self.DetectedPlayers > 0
    end
end

-- Function to store player model information using Helix character ID
function ENT:StorePlayerModel(ply)
    if IsValid(ply) and ply:IsPlayer() then
        local character = ply:GetCharacter()
        if character then
            local charID = character:GetID()
            local model = ply:GetModel()
            if model and charID then
                self.DetectedPlayerModels[charID] = model
            end
        end
    end
end

-- Function to create the light sprite above the trace lines with quick fade in, long hold, and quick fade out
function ENT:CreateLightSprite()
    local spritePos = self:GetPos() + self:GetUp() * 23 + self:GetForward() * 13 -- Move the sprite down closer to the entity and forward

    local lightSprite = ents.Create("env_sprite")
    if IsValid(lightSprite) then
        lightSprite:SetKeyValue("model", "sprites/light_glow01.vmt") -- Use a basic light glow sprite
        lightSprite:SetKeyValue("rendercolor", "255 255 255") -- White color
        lightSprite:SetKeyValue("GlowProxySize", "3") -- Size of the glow (not affecting sprite size)
        lightSprite:SetKeyValue("HDRColorScale", "1.0") -- Brightness scale
        lightSprite:SetKeyValue("renderfx", "0") -- No special effects
        lightSprite:SetKeyValue("rendermode", "3") -- Normal mode
        lightSprite:SetKeyValue("disablereceiveshadows", "1")
        lightSprite:SetKeyValue("spawnflags", "1") -- Start on
        lightSprite:SetKeyValue("scale", "2.0") -- Decrease the scale for a smaller sprite (This affects the actual size)

        lightSprite:SetPos(spritePos)
        lightSprite:SetParent(self) -- Attach the sprite to the entity
        lightSprite:Spawn()
        lightSprite:Activate()

        -- Quick fade in the sprite
        local alpha = 50 -- Start the sprite at a higher initial opacity
        lightSprite:SetColor(Color(255, 255, 255, alpha))

        timer.Create("FadeInSprite", 0.025, 10, function()
            if IsValid(lightSprite) then
                alpha = math.min(alpha + 25.5, 255)
                lightSprite:SetColor(Color(255, 255, 255, alpha))
            end
        end)

        -- Hold the sprite at full visibility for 4 seconds
        timer.Simple(0.25, function()
            timer.Simple(4, function()
                -- Quick fade out the sprite
                timer.Create("FadeOutSprite", 0.025, 10, function()
                    if IsValid(lightSprite) then
                        alpha = math.max(alpha - 25.5, 0)
                        lightSprite:SetColor(Color(255, 255, 255, alpha))
                        if alpha <= 0 then
                            lightSprite:Remove()
                        end
                    end
                end)
            end)
        end)
    end
end

-- Think function to continuously check for players
function ENT:Think()
    self:DetectPlayers()
    self:NextThink(CurTime() + 0.1) -- Check every 0.1 second for better responsiveness
    return true
end

-- Handle player interaction (Use key)
function ENT:Use(activator, caller)
    if IsValid(activator) and activator:IsPlayer() then
        local currentTime = CurTime()

        -- Check if the cooldown has passed
        if currentTime >= self.NextUseTime then
            self:EmitSound("npc/scanner/scanner_photo1.wav") -- Emit a sound when the entity is used for debugging

            -- Set the next use time to 15 seconds from now
            self.NextUseTime = currentTime + 15

            -- Create the light sprite above the trace lines
            self:CreateLightSprite()

            -- Trigger the flash effect and store model information for all detected players
            for _, ply in ipairs(self.DetectedPlayers) do
                self:StorePlayerModel(ply)
                ply:SendLua("TriggerPlayerFlash()")
            end

        else
            -- Check if the cooldown message can be shown
            if currentTime >= self.NextMessageTime then
                activator:ChatPrint("The camera is cooling down. Please wait.")
                self.NextMessageTime = currentTime + 14 -- Set the next message time to 14 seconds from now
            end
        end
    end
end

-- Client-side rendering (Draw the entity)
if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end
