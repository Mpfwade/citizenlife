AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

SWEP.Base = "ls_base"

SWEP.PrintName = "Handmade Shotgun"
SWEP.Category = "CL Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "shotgun"

SWEP.WorldModel = "models/weapons/w_annabelle.mdl"
SWEP.ViewModel = "models/weapons/yurie_rustalpha/c-vm-pipeshotgun.mdl"
SWEP.ViewModelFOV = 65

SWEP.LowerAngles = Angle(10, -5, -5)
SWEP.LowerAngles2 = Angle(10, -5, -5)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = "Weapon_AR2.Reload"
SWEP.EmptySound = ""

SWEP.Primary.Sound = "weapons/shotgun/shotgun_fire6.wav"
SWEP.Primary.Recoil = 25
SWEP.Primary.Damage = 3.5
SWEP.Primary.NumShots = 27
SWEP.Primary.Cone = 0.200
SWEP.Primary.Delay = RPM(80)
SWEP.PenetrationScale = 2

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.DoEmptyReloadAnim = false

SWEP.Spread = {}
SWEP.Spread.Min = 0.200
SWEP.Spread.Max = 0.200
SWEP.Spread.IronsightsMod = 1 -- multiply
SWEP.Spread.CrouchMod = 1 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.01 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.15 -- movement speed effect on spread (additonal)

SWEP.ViewModelOffset = Vector(1, 3, -2)

SWEP.IronsightsPos = Vector(1,10,3)
SWEP.IronsightsAng = Angle(-0.52, 1, 0)
SWEP.IronsightsFOV = 0.85
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1.3