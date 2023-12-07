AddCSLuaFile()

SWEP.Base = "ls_base_melee"

SWEP.PrintName = "Katana"
SWEP.Category = "CL Weapons"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "melee2"

SWEP.WorldModel = Model("models/weapons/w_katana.mdl")
SWEP.ViewModel = Model("models/weapons/v_katana.mdl")
SWEP.ViewModelFOV = 60

SWEP.Slot = 0
SWEP.SlotPos = 4
SWEP.UseHands = false

--SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("weapons/iceaxe/iceaxe_swing1.wav")
SWEP.Primary.ImpactSound = Sound("npc/scanner/scanner_nearmiss1.wav")
SWEP.Primary.Recoil = 3.2 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 47 -- not used in this swep
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.7
SWEP.Primary.HitDelay = 0.4
SWEP.Primary.Range = 82
SWEP.Primary.StunTime = 0.8
SWEP.Primary.HullSize = 7