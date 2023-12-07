ENT.Type = "anim"
ENT.PrintName = "CWU Safebox"
ENT.Category = "IX:HL2RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true

if ( SERVER ) then
	function ENT:Initialize()
		self:SetModel("models/props_junk/cardboard_box002b.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:Wake()
		end
	end

	function ENT:SpawnFunction(ply, trace)
		local angles = ply:GetAngles()
	
		local entity = ents.Create("ix_cwusafebox")
		entity:SetPos(trace.HitPos)
		entity:SetAngles(Angle(0, (entity:GetPos() - ply:GetPos()):Angle().y - 180, 0))
		entity:Spawn()
		entity:Activate()
	
		return entity
	end

	function ENT:Use(activator)
		if (CurTime() < (activator.ixNextOpen or 0)) then
			return
		end
		

		if ( activator:IsCombine() or activator:IsCA() or activator:GetCharacter():GetClass() == CLASS_CITIZEN) then
			activator:Notify("You need to be a worker to use worker safeboxes!")
			return
		end

		local openTime = ix.config.Get("safeboxOpenTime", 1)

		ix.safebox.Restore(activator, function()
			if (openTime > 0) then
				activator:SetAction("@storageSearching", openTime)
				activator:DoStaredAction(self, function()
					if (IsValid(activator) and activator:Alive()) then
						net.Start("ixSafeboxOpen")
						net.Send(activator)
					end
				end, openTime, function()
					if (IsValid(activator)) then
						activator:SetAction()
					end
				end)
			else
				net.Start("ixSafeboxOpen")
				net.Send(activator)
			end
		end)

		activator.ixNextOpen = CurTime() + 1
	end
end