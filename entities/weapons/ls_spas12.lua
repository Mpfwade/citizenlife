AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

SWEP.Base = "ls_base_shotgun"

SWEP.PrintName = "Spas-12 Shotgun"
SWEP.Category = "CL Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "shotgun"

SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.ViewModelFOV = 65

SWEP.LowerAngles = Angle(5, -5, -5)
SWEP.LowerAngles2 = Angle(5, -5, -5)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadShellSound = "Weapon_Shotgun.Reload"
SWEP.EmptySound = "Weapon_Shotgun.Empty"

SWEP.Primary.Sound = "Weapon_Shotgun.Single"
SWEP.Primary.Recoil = 29
SWEP.Primary.Damage = 10
SWEP.Primary.NumShots = 12
SWEP.Primary.Cone = 0.100
SWEP.Primary.Delay = RPM(80)
SWEP.PenetrationScale = 2

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.DoEmptyReloadAnim = false

SWEP.Spread = {}
SWEP.Spread.Min = 0.100
SWEP.Spread.Max = 0.2
SWEP.Spread.IronsightsMod = 1 -- multiply
SWEP.Spread.CrouchMod = 1 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.01 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.15 -- movement speed effect on spread (additonal)

SWEP.ViewModelOffset = Vector(0, 0, 0)

SWEP.IronsightsPos = Vector(1,0,1)
SWEP.IronsightsAng = Angle(-0.52, 1, 0)
SWEP.IronsightsFOV = 0.90
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1.3