AddCSLuaFile()

SWEP.Base = "ls_base_melee"

SWEP.PrintName = "Broken Bottle"
SWEP.Category = "CL Weapons"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "knife"

SWEP.WorldModel = Model("models/weapons/hl2meleepack/w_brokenbottle.mdl")
SWEP.ViewModel = Model("models/weapons/hl2meleepack/v_brokenbottle.mdl")
SWEP.ViewModelFOV = 65

SWEP.Slot = 0
SWEP.SlotPos = 3

--SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("WeaponFrag.Roll")
SWEP.Primary.ImpactSound = Sound("Canister.ImpactHard")
SWEP.Primary.Recoil = 1.1 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 2 -- not used in this swep
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.7
SWEP.Primary.HitDelay = 0.3
SWEP.Primary.Range = 65
SWEP.Primary.StunTime = 0.2