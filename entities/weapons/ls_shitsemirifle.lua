AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

SWEP.Base = "ls_base"

SWEP.PrintName = "Handmade Semi-Automatic Rifle"
SWEP.Category = "CL Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "shotgun"

SWEP.WorldModel = "models/weapons/darky_m/rust/w_sar.mdl"
SWEP.ViewModel = "models/weapons/darky_m/rust/c_sar.mdl"
SWEP.ViewModelFOV = 65

SWEP.LowerAngles = Angle(10, -5, -5)
SWEP.LowerAngles2 = Angle(10, -5, -5)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = "weapons/ar2/npc_ar2_reload.wav"
SWEP.EmptySound = "Weapon_Shotun.Empty"

SWEP.Primary.Sound = "weapons/yurie_rustalpha/revolver/revolver_fire_sharp.ogg"
SWEP.Primary.Recoil = 3
SWEP.Primary.Damage = 4.3
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.Delay = RPM(80)
SWEP.PenetrationScale = 2

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 25

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.DoEmptyReloadAnim = false

SWEP.Spread = {}
SWEP.Spread.Min = 0.01
SWEP.Spread.Max = 0.02
SWEP.Spread.IronsightsMod = 1 -- multiply
SWEP.Spread.CrouchMod = 1 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.01 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.15 -- movement speed effect on spread (additonal)

SWEP.ViewModelOffset = Vector(1, 3, -2)

SWEP.IronsightsPos = Vector(1,10,2)
SWEP.IronsightsAng = Angle(0,0,0)
SWEP.IronsightsFOV = 0.75
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 0.4