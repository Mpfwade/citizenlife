AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "CITIZENLIFE-TV"
ENT.Author = "Wade"
ENT.Category = "IX:HL2RP"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true

ENT.Materials = {Material("perftest/dev_tvmonitor1a"), Material("scripted/breen_fakemonitor_1"), Material("effects/breenscreen_static01_"), Material("effects/tvscreen_noise001a")}

ENT.MaterialDuration = math.random(3, 9) -- Duration for each material (in seconds)

ENT.TVSoundinstinct = {"vo/breencast/br_instinct01.wav", "vo/breencast/br_instinct02.wav", "vo/breencast/br_instinct03.wav", "vo/breencast/br_instinct04.wav", "vo/breencast/br_instinct05.wav", "vo/breencast/br_instinct06.wav", "vo/breencast/br_instinct07.wav", "vo/breencast/br_instinct08.wav", "vo/breencast/br_instinct09.wav", "vo/breencast/br_instinct10.wav", "vo/breencast/br_instinct11.wav", "vo/breencast/br_instinct12.wav", "vo/breencast/br_instinct13.wav", "vo/breencast/br_instinct14.wav", "vo/breencast/br_instinct15.wav", "vo/breencast/br_instinct16.wav", "vo/breencast/br_instinct17.wav", "vo/breencast/br_instinct18.wav", "vo/breencast/br_instinct19.wav", "vo/breencast/br_instinct20.wav", "vo/breencast/br_instinct21.wav", "vo/breencast/br_instinct22.wav", "vo/breencast/br_instinct23.wav", "vo/breencast/br_instinct24.wav", "vo/breencast/br_instinct25.wav"}

ENT.TVSoundwelcome = {"vo/breencast/br_welcome01.wav", "vo/breencast/br_welcome02.wav", "vo/breencast/br_welcome03.wav", "vo/breencast/br_welcome04.wav", "vo/breencast/br_welcome05.wav", "vo/breencast/br_welcome06.wav", "vo/breencast/br_welcome07.wav"}

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_c17/tv_monitor01.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        local physics = self:GetPhysicsObject()

        if physics:IsValid() then
            physics:Wake()
            physics:SetMass(50)
        end

        self:StartMotionController()
        self.IsActivated = false -- Flag to track activation status
        self:SetNWBool("TV_Activated", self.IsActivated) -- Networked variable for activation status
        self:SetNWInt("TV_MaterialIndex", 1) -- Networked variable for current material index
        self.NextMaterialTime = 0 -- Time to change to the next material
        self.SoundTimer = nil -- Timer for playing sounds
        self.IsScreenVisible = false
    end

    function ENT:SpawnFunction(ply, trace)
        local tv = ents.Create("ix_tv")
        tv:SetPos(trace.HitPos + Vector(0, 0, 48))
        tv:SetAngles(Angle(0, (tv:GetPos() - ply:GetPos()):Angle().y - 180, 0))
        tv:Spawn()

        return tv
    end

    function ENT:ToggleActivation()
        self.IsActivated = not self.IsActivated
        self:SetNWBool("TV_Activated", self.IsActivated)
    
        if self.IsActivated then
            self:EmitSound("buttons/lightswitch2.wav", 75, 100)
            local curTime = CurTime()
    
            if self.NextMaterialTime <= curTime then
                local materialIndex = self:GetNWInt("TV_MaterialIndex")
                materialIndex = materialIndex % #self.Materials + 1
                self:SetNWInt("TV_MaterialIndex", materialIndex)
                local material = self.Materials[materialIndex]
                -- Set the material for the screen
                local screen = self:GetNWEntity("TV_Screen")
    
                if IsValid(screen) then
                    screen:SetMaterial(material)
                end
    
                local soundTable = self.TVSoundinstinct
                local additionalDuration = 2.05
    
                if math.random(2) == 1 then
                    soundTable = self.TVSoundwelcome
                    additionalDuration = 5
                end
    
                if soundTable then
    
                    -- Play the first sound immediately with DSP effect
                    local soundIndex = 1
                    local soundPath = soundTable[soundIndex]
                    local soundDuration = SoundDuration(soundPath) + additionalDuration
                    self:EmitSound(soundPath, 75, 100, 1, CHAN_STATIC, 0, 59)
    
                    -- Create a timer to play the remaining sounds with DSP effect
                    local soundCount = #soundTable
                    self.SoundTimer = timer.Create("TV_SoundTimer_" .. self:EntIndex(), soundDuration, soundCount - 1, function()
                        -- Check if the TV is still activated
                        if self:IsValid() and self.IsActivated then
                            soundIndex = soundIndex % soundCount + 1
                            soundPath = soundTable[soundIndex]
                            soundDuration = SoundDuration(soundPath) + additionalDuration
                            self:EmitSound(soundPath, 75, 100, 1, CHAN_STATIC, 0, 59)
                        end
                    end)
                end
    
                self.NextMaterialTime = curTime + self.MaterialDuration
    
                -- Check if reached the last material
                if materialIndex == #self.Materials then
                    self.NextMaterialTime = curTime + self.MaterialDuration * #self.Materials
                end
            end
        else
            self:EmitSound("buttons/lightswitch2.wav", 75, 100)
            -- Stop all sounds
            self:StopAllSounds()
            self:SetNWInt("TV_MaterialIndex", 1) -- Reset the material index to the first material
            self:SetNWEntity("TV_Screen", nil) -- Clear the screen entity
            self.NextMaterialTime = 0 -- Reset the material change time
        end
    end
    
    function ENT:StopAllSounds()
        if self.SoundTimer then
            timer.Remove("TV_SoundTimer_" .. self:EntIndex())
            self.SoundTimer = nil
        end

        local soundTable = self.TVSoundinstinct

        if soundTable then
            for _, sound in ipairs(soundTable) do
                self:StopSound(sound)
            end
        end

        soundTable = self.TVSoundwelcome

        if soundTable then
            for _, sound in ipairs(soundTable) do
                self:StopSound(sound)
            end

            soundTable = self.TVSoundwelcome and self.TVSoundinstinct

            if soundTable then
                for _, sound in ipairs(soundTable) do
                    self:StopSound(sound)
                end
            end
        end
    end

    function ENT:Use(activator, caller)
        if not IsValid(caller) or not caller:IsPlayer() then return end
        self:ToggleActivation()
    end

    function ENT:RefreshDisplay()
        if not self:IsValid() then return end
        self.NextMaterialTime = CurTime() + self.MaterialDuration
        -- Get the current material index
        local materialIndex = self:GetNWInt("TV_MaterialIndex")
        materialIndex = materialIndex % #self.Materials + 1

        -- Check if reached the last material, loop back to the first material
        if materialIndex == #self.Materials then
            materialIndex = 1
        end

        self:SetNWInt("TV_MaterialIndex", materialIndex)
        local material = self.Materials[materialIndex]
        -- Set the material for the screen
        local screen = self:GetNWEntity("TV_Screen")

        if IsValid(screen) then
            screen:SetMaterial(material)
        end
    end

    function ENT:Think()
        local curTime = CurTime()

        if self.IsActivated and self.MaterialDuration > 0 and self.NextMaterialTime <= curTime then
            self:RefreshDisplay()
            self.NextMaterialTime = curTime + self.MaterialDuration
        end

        self:NextThink(curTime)

        return true
    end

    function ENT:OnRemove()
        self:StopAllSounds()
        -- Clear the material on removal
        local screen = self:GetNWEntity("TV_Screen")

        if IsValid(screen) then
            screen:SetMaterial("")
        end
    end
else
    function ENT:Draw()
        self:DrawModel()
        if not self:GetNWBool("TV_Activated") then return end
        local pos = self:GetPos()
        local ang = self:GetAngles()
        pos = pos + (ang:Up() * 5)
        pos = pos + (ang:Forward() * 6.30)
        pos = pos + (ang:Right() * 9.8)
        ang:RotateAroundAxis(self:GetAngles():Up(), 90)
        ang:RotateAroundAxis(self:GetAngles():Right(), -90)
        cam.Start3D2D(pos, ang, 0.07)
        surface.SetDrawColor(Color(30, 30, 30))
        local materialIndex = self:GetNWInt("TV_MaterialIndex")
        local material = self.Materials[materialIndex]
        surface.SetMaterial(material)
        surface.DrawTexturedRect(10, -11, 215, 145)
        cam.End3D2D()
    end
end