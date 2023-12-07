AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

SWEP.Base = "ls_base"

SWEP.PrintName = "Handmade Pistol"
SWEP.Category = "CL Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "pistol"

SWEP.WorldModel = "models/weapons/darky_m/rust/w_nailgun.mdl"
SWEP.ViewModel = "models/weapons/darky_m/rust/c_nailgun.mdl"
SWEP.ViewModelFOV = 60

SWEP.LowerAngles = Angle(5, -5, -5)
SWEP.LowerAngles2 = Angle(5, -5, -5)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = "weapons/yurie_rustalpha/revolver/revolver_reload_placeholder.wav"
SWEP.EmptySound = "Weapon_PISTOL.Empty"

SWEP.Primary.Sound = "weapons/alyx_gun/alyx_gun_fire4.wav"
SWEP.Primary.Recoil = 5
SWEP.Primary.Damage = 2.2
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Delay = RPM(165)
SWEP.PenetrationScale = 3

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0.09
SWEP.Spread.Max = 0.5
SWEP.Spread.IronsightsMod = 0 -- multiply
SWEP.Spread.CrouchMod = 0 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 2 -- movement speed effect on spread (additonal)

SWEP.DoEmptyReloadAnim = false
SWEP.UseIronsightsRecoil = false
SWEP.ViewModelOffset = Vector(0, 0, 0)

SWEP.IronsightsPos = Vector(1, 5, 2)
SWEP.IronsightsAng = Angle(-0.52, 1, 0)
SWEP.IronsightsFOV = 0.75
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1.3

SWEP.IronsightsRecoilRecoveryRate = 1
SWEP.IronsightsRecoilYawTarget = 0
SWEP.IronsightsRecoilYawMax = 0
SWEP.IronsightsRecoilYawMin = 0
SWEP.IronsightsRecoilPitchMultiplier = 0.1
SWEP.scopedIn = false

