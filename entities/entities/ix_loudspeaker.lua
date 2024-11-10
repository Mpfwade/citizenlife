AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "CITIZENLIFE-Speaker"
ENT.Author = "Wade"
ENT.Category = "IX:HL2RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true
ENT.SpeakerSoundwelcome = {"c17/welcome.wav", "c17/instinct.wav"}
ENT.CooldownDuration = 5
ENT.Damaged = false
ENT.MaxHits = 3
ENT.HitCount = 0

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_wasteland/speakercluster01a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
            phys:SetMass(50)
        end

        self.IsActivated = true
        self:SetNWBool("Speaker_Activated", self.IsActivated)
        self:PlaySoundSequence()
    end

    function ENT:OnTakeDamage(dmginfo)
        if self.Damaged then return end

        self.HitCount = self.HitCount + 1
        if self.HitCount >= self.MaxHits then
            self.Damaged = true
            self.IsActivated = false
            self:SetNWBool("Speaker_Activated", self.IsActivated)
            self:StopAllSounds()
            self:EmitSound("ambient/voices/squeal1.wav", 85, 100)
            print("Speaker has been damaged and will no longer operate.")
            self:PlayBrokenSounds() -- Start playing broken sounds
        end
    end

    function ENT:Use(activator, caller)
        if self.Damaged then
            local item = activator:GetCharacter():GetInventory():HasItem("emp") -- Assuming the item's unique ID is "repair_kit"
            if item then
                item:Remove() -- Remove the item from the player's inventory
                self.Damaged = false
                self.IsActivated = true
                self.HitCount = 0
                self:SetNWBool("Speaker_Activated", self.IsActivated)
                self:EmitSound("ambient/energy/weld2.wav", 85, 100) -- Sound effect for repairing
                self:PlaySoundSequence() -- Resume normal operation
                return
            else
                self:PlayBrokenSounds() -- Continue playing broken sounds
                return
            end
        end
    
        self.IsActivated = not self.IsActivated
        self:SetNWBool("Speaker_Activated", self.IsActivated)
        if self.IsActivated then
            self:PlaySoundSequence()
        else
            self:StopAllSounds()
        end
    end

    function ENT:PlaySoundSequence()
        if not self.IsActivated or self.Damaged then return end
        local soundsToPlay = self:GetSoundsToPlay()
        local soundPath = soundsToPlay[math.random(#soundsToPlay)]
        local soundDuration = SoundDuration(soundPath) + self.CooldownDuration

        self:EmitSound(soundPath, 85, 100, 1, CHAN_AUTO)
        timer.Create("SpeakerSoundSequence" .. self:EntIndex(), soundDuration, 1, function()
            if IsValid(self) and self.IsActivated and not self.Damaged then
                self:PlaySoundSequence()
            end
        end)
    end

    function ENT:GetSoundsToPlay()
        return ix.config.Get("cityCode", 0) == 1 and {"c17/disruptor.wav"} or self.SpeakerSoundwelcome
    end

    function ENT:StopAllSounds()
        self:StopSound("c17/disruptor.wav")
        self:StopSound("c17/welcome.wav")
        self:StopSound("c17/instinct.wav")
        timer.Remove("SpeakerSoundSequence" .. self:EntIndex())
    end

    function ENT:PlayBrokenSounds()
        local brokenSounds = {"ambient/energy/zap1.wav", "ambient/energy/zap2.wav", "ambient/energy/zap3.wav"}
        local randomSound = brokenSounds[math.random(#brokenSounds)]
        self:EmitSound(randomSound, 85, 100)
        local randomInterval = math.random(5, 10)

        timer.Create("BrokenSpeakerSounds" .. self:EntIndex(), randomInterval, 1, function()
            if IsValid(self) and self.Damaged then
                self:PlayBrokenSounds()
            end
        end)
    end

    function ENT:OnRemove()
        self:StopAllSounds()
        timer.Remove("BrokenSpeakerSounds" .. self:EntIndex()) -- Ensure to remove the broken sounds timer
    end
end