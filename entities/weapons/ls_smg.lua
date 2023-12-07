AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

SWEP.Base = "ls_base"

SWEP.PrintName = "SMG"
SWEP.Category = "CL Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "smg"

SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.ViewModelFOV = 60

SWEP.LowerAngles = Angle(5, -5, -5)
SWEP.LowerAngles2 = Angle(5, -5, -5)

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = "weapons/smg1/smg1_reload.wav"
SWEP.EmptySound = "weapons/smg1/switch_single.wav"

SWEP.Primary.Sound = "weapons/smg1/smg1_fire1.wav"
SWEP.Primary.Recoil = 2
SWEP.Primary.Damage = 15
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.05
SWEP.Primary.Delay = RPM(800)
SWEP.PenetrationScale = 3

SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 45
SWEP.Primary.DefaultClip = 45

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0.1
SWEP.Spread.Max = 0.2
SWEP.Spread.IronsightsMod = 0 -- multiply
SWEP.Spread.CrouchMod = 0 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 2 -- movement speed effect on spread (additonal)

SWEP.DoEmptyReloadAnim = false
SWEP.UseIronsightsRecoil = false
SWEP.ViewModelOffset = Vector(0, 0, 0)

SWEP.IronsightsPos = Vector(-1,5,1)
SWEP.IronsightsAng = Angle(0,0,0)
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

