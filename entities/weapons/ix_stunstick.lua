AddCSLuaFile()
if CLIENT then
    SWEP.PrintName = "Stunstick"
    SWEP.Slot = 1
    SWEP.SlotPos = 2
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.Category = "IX:HL2RP"
SWEP.Author = "Chessnut"
SWEP.Instructions = "Primary Fire: Stun.\nALT + Primary Fire: Toggle stun.\nSecondary Fire: Push/Knock."
SWEP.Purpose = "Hitting things and knocking on doors."
SWEP.Drop = false
SWEP.HoldType = "melee"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "melee"
SWEP.ViewTranslation = 4
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Damage = 3
SWEP.Primary.Delay = 0.7
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.UseHands = true
SWEP.LowerAngles = Angle(15, -10, -20)
SWEP.FireWhenLowered = true
function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "Activated")
end

function SWEP:Precache()
    util.PrecacheSound("physics/wood/wood_crate_impact_hard3.wav")
end

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function SWEP:OnRaised()
    self.lastRaiseTime = CurTime()
end

function SWEP:OnLowered()
    self:SetActivated(false)
end

function SWEP:Holster(nextWep)
    self:OnLowered()
    return true
end

local STUNSTICK_GLOW_MATERIAL = Material("effects/stunstick")
local STUNSTICK_GLOW_MATERIAL2 = Material("effects/blueflare1")
local STUNSTICK_GLOW_MATERIAL_NOZ = Material("sprites/light_glow02_add_noz")
local color_glow = Color(128, 128, 128)
function SWEP:DrawWorldModel()
    self:DrawModel()
    if self:GetActivated() then
        local size = math.Rand(4.0, 6.0)
        local glow = math.Rand(0.6, 0.8) * 255
        local color = Color(glow, glow, glow)
        local attachment = self:GetAttachment(1)
        if attachment then
            local position = attachment.Pos
            render.SetMaterial(STUNSTICK_GLOW_MATERIAL2)
            render.DrawSprite(position, size * 2, size * 2, color)
            render.SetMaterial(STUNSTICK_GLOW_MATERIAL)
            render.DrawSprite(position, size, size + 3, color_glow)
        end
    end
end

local NUM_BEAM_ATTACHEMENTS = 9
local BEAM_ATTACH_CORE_NAME = "sparkrear"
function SWEP:PostDrawViewModel()
    if not self:GetActivated() then return end
    local viewModel = LocalPlayer():GetViewModel()
    if not IsValid(viewModel) then return end
    cam.Start3D(EyePos(), EyeAngles())
    local size = math.Rand(3.0, 3.5)
    local color = Color(255, 255, 255, 50 + math.sin(RealTime() * 2) * 20)
    STUNSTICK_GLOW_MATERIAL_NOZ:SetFloat("$alpha", color.a / 255)
    render.SetMaterial(STUNSTICK_GLOW_MATERIAL_NOZ)
    local attachment = viewModel:GetAttachment(viewModel:LookupAttachment(BEAM_ATTACH_CORE_NAME))
    if attachment then render.DrawSprite(attachment.Pos, size * 10, size * 15, color) end
    for i = 1, NUM_BEAM_ATTACHEMENTS do
        attachment = viewModel:GetAttachment(viewModel:LookupAttachment("spark" .. i .. "a"))
        size = math.Rand(7.0, 10.0)
        if attachment and attachment.Pos then render.DrawSprite(attachment.Pos, size, size, color) end
        attachment = viewModel:GetAttachment(viewModel:LookupAttachment("spark" .. i .. "b"))
        size = math.Rand(7.0, 10.0)
        if attachment and attachment.Pos then render.DrawSprite(attachment.Pos, size, size, color) end
    end

    cam.End3D()
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    if not self:GetOwner():IsWepRaised() then return end
    if self:GetOwner():KeyDown(IN_WALK) then
        if SERVER then
            self:SetActivated(not self:GetActivated())
            local state = self:GetActivated()
            if state then
                self:GetOwner():EmitSound("Weapon_StunStick.Activate")
                if CurTime() < self.lastRaiseTime + 1.5 then self:GetOwner():AddCombineDisplayMessage("Preparing civil judgement administration protocols...") end
            else
                self:GetOwner():EmitSound("Weapon_StunStick.Deactivate")
            end

            local model = string.lower(self:GetOwner():GetModel())
            if ix.anim.GetModelClass(model) == "metrocop" then self:GetOwner():ForceSequence(state and "activatebaton" or "deactivatebaton", nil, nil, true) end
        end
        return
    end

    self:EmitSound("Weapon_StunStick.Swing")
    self:SendWeaponAnim(ACT_VM_HITCENTER)
    local damage = self.Primary.Damage
    if self:GetActivated() then damage = 0.5 end
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    self:GetOwner():ViewPunch(Angle(1, 0, 0.125))
    self:GetOwner():LagCompensation(true)
    local data = {}
    data.start = self:GetOwner():GetShootPos()
    data.endpos = data.start + self:GetOwner():GetAimVector() * 72
    data.filter = self:GetOwner()
    data.mins = Vector(-6, -6, -20) -- Adjusted hitbox size (lowered further)
    data.maxs = Vector(6, 6, -10) -- Adjusted hitbox size (lowered further)
    local trace = util.TraceHull(data)
    self:GetOwner():LagCompensation(false)
    if SERVER and trace.Hit then
        if self:GetActivated() then
            local effect = EffectData()
            effect:SetStart(trace.HitPos)
            effect:SetNormal(trace.HitNormal)
            effect:SetOrigin(trace.HitPos)
            util.Effect("StunstickImpact", effect, true, true)
        end

        self:GetOwner():EmitSound("Weapon_StunStick.Melee_HitWorld")
        local entity = trace.Entity
        if IsValid(entity) then
            if entity:IsPlayer() then
                if self:GetActivated() then
                    entity.ixStuns = (entity.ixStuns or 0) + 1
                    timer.Simple(10, function() entity.ixStuns = math.max(entity.ixStuns - 1, 0) end)
                end

                entity:ViewPunch(Angle(-20, math.random(-15, 15), math.random(-10, 10)))
                entity:ScreenFade(SCREENFADE.IN, Color(256, 256, 256, 255), 5, 0)
                if self:GetActivated() and entity.ixStuns > 3 then
                    local team = entity:Team()
                    entity:ShouldSetRagdolled(true)
                    entity:SetNWBool("Ragdolled", true)
                    entity:SetNWBool("Healed", false)
                    entity:Freeze(true)
                    if team ~= FACTION_CA and team ~= FACTION_OTA then
                        entity:EmitSound("npc/vort/foot_hit.wav")
                    elseif team == FACTION_CCA then
                        entity:EmitSound("npc/metropolice/knockout2.wav")
                    elseif team == FACTION_OTA then
                        entity:EmitSound("npc/combine_soldier/pain2.wav")
                    end

                    ix.chat.Send(entity, "me", "'s body crumbles to the ground.")
                    entity:SetAction("You Are Unconscious...", 35, function()

                            entity:SetNWBool("Ragdolled", false)
                            entity:ShouldSetRagdolled(false)
                            entity:Freeze(false)
             
                            -- Check the restriction status a bit later to ensure it's up-to-date
                            timer.Simple(0.1, function()
                                if IsValid(entity) then
                                    if entity:IsRestricted() then
                                        entity:SetRestricted(true)
                                    else
                                        entity:SelectWeapon("ix_hands")
                                    end
                                end
                            end)
                        end
                    )

                elseif entity:IsRagdoll() or entity:GetNWBool("Ragdolled") then
                    damage = self:GetActivated() and 2 or 10
                end
            end

            local damageInfo = DamageInfo()
            damageInfo:SetAttacker(self:GetOwner())
            damageInfo:SetInflictor(self)
            damageInfo:SetDamage(damage)
            damageInfo:SetDamageType(DMG_CLUB)
            damageInfo:SetDamagePosition(trace.HitPos)
            damageInfo:SetDamageForce(self:GetOwner():GetAimVector() * 10000)
            if not entity:GetNWBool("Ragdolled") or entity:IsRagdoll() then entity:DispatchTraceAttack(damageInfo, data.start, data.endpos) end
        end
    end
end

function SWEP:SecondaryAttack()
    self:GetOwner():LagCompensation(true)
    local data = {}
    data.start = self:GetOwner():GetShootPos()
    data.endpos = data.start + self:GetOwner():GetAimVector() * 72
    data.filter = self:GetOwner()
    data.mins = Vector(-8, -8, -30)
    data.maxs = Vector(8, 8, 10)
    local trace = util.TraceHull(data)
    local entity = trace.Entity
    self:GetOwner():LagCompensation(false)
    if SERVER and IsValid(entity) then
        local bPushed = false
        if entity:IsDoor() then
            if hook.Run("PlayerCanKnockOnDoor", self:GetOwner(), entity) == false then return end
            self:GetOwner():ViewPunch(Angle(-1.3, 1.8, 0))
            self:GetOwner():EmitSound("physics/wood/wood_crate_impact_hard3.wav")
            self:GetOwner():SetAnimation(PLAYER_ATTACK1)
            self:SetNextSecondaryFire(CurTime() + 0.4)
            self:SetNextPrimaryFire(CurTime() + 1)
        elseif entity:IsPlayer() then
            local direction = self:GetOwner():GetAimVector() * (300 + (self:GetOwner():GetCharacter():GetAttribute("str", 0) * 3))
            direction.z = 0
            entity:SetVelocity(direction)
            bPushed = true
        else
            local physObj = entity:GetPhysicsObject()
            if IsValid(physObj) then physObj:SetVelocity(self:GetOwner():GetAimVector() * 180) end
            bPushed = true
        end

        if bPushed then
            self:SetNextSecondaryFire(CurTime() + 1.5)
            self:SetNextPrimaryFire(CurTime() + 1.5)
            self:GetOwner():EmitSound("Weapon_Crossbow.BoltHitBody")
            local model = string.lower(self:GetOwner():GetModel())
            if ix.anim.GetModelClass(model) == "metrocop" then self:GetOwner():ForceSequence("pushplayer") end
        end
    end
end