-- Item Statistics

ITEM.name = "IED"
ITEM.description = "A Bomb filled with explosives and a timer."
ITEM.category = "Weapons"

-- Item Configuration

ITEM.model = "models/weapons/w_c4_planted.mdl"
ITEM.skin = 0
ITEM.price = 3700

local function PlayBeep(time, ent)
	timer.Simple(time or 0, function()
		if ent:IsValid() then
			ent:EmitSound("weapons/c4/c4_click.wav", 90)
		end
	end)
end

ITEM.functions.PlaceVehicle = {
	name = "Place on Vehicle",
	OnCanRun = function(item)
		local ply = item.player
		local data = {}
			data.start = ply:GetShootPos()
			data.endpos = data.start + ply:GetAimVector() * 96
			data.filter = ply
		local ent = util.TraceLine(data).Entity

		if ( ent:IsValid() and ent:GetClass() == "gmod_sent_vehicle_fphysics_base" ) then
			return true
		else
			return false
		end
	end,
	OnRun = function(item)
		local ply = item.player
		local data = {}
			data.start = ply:GetShootPos()
			data.endpos = data.start + ply:GetAimVector() * 96
			data.filter = ply
		local ent = util.TraceLine(data).Entity

		if ( ent:IsValid() and ent:GetClass() == "gmod_sent_vehicle_fphysics_base" ) then
			local entityPosition = ent:GetPos()
			ent:EmitSound("weapons/c4/c4_disarm.wav", 90)
			PlayBeep(0.5, ent)
			PlayBeep(1.5, ent)
			PlayBeep(2.5, ent)
			PlayBeep(3, ent)
			PlayBeep(3.25, ent)
			PlayBeep(3.50, ent)
			PlayBeep(3.75, ent)
			timer.Simple(4, function()
				if ( IsValid(ent) ) then
					entityPosition = ent:GetPos()
					local explode = ents.Create("env_explosion")
					explode:SetPos(entityPosition)
					explode:SetOwner(ply)
					explode:Spawn()
					explode:SetKeyValue("iMagnitude", "375")
					explode:Fire("Explode", 0, 0)
					explode:EmitSound("weapons/c4/c4_explode1.wav", 120)
					explode:EmitSound("weapons/c4/c4_exp_deb1.wav", 100)
					explode:EmitSound("weapons/c4/c4_exp_deb2.wav", 100)
				end
			end)
		end

		return true
	end
}

ITEM.functions.Arm = {
	name = "Arm on yourself",
	OnRun = function(item)
		local ply = item.player
		
		ply:EmitSound("weapons/c4/c4_disarm.wav", 80)
		PlayBeep(0.5, ply)
		PlayBeep(1.5, ply)
		PlayBeep(2.5, ply)
		PlayBeep(3, ply)
		PlayBeep(3.25, ply)
		PlayBeep(3.50, ply)
		PlayBeep(3.75, ply)
		timer.Simple(4, function()
			if ( IsValid(ply) and ply:Alive() ) then
				local explode = ents.Create("env_explosion")
				explode:SetPos(ply:GetPos())
				explode:SetOwner(ply)
				explode:Spawn()
				explode:SetKeyValue("iMagnitude", "500")
				explode:Fire("Explode", 0, 0)
				explode:EmitSound("weapons/c4/c4_explode1.wav", 100)
				explode:EmitSound("weapons/c4/c4_exp_deb1.wav", 90)
				explode:EmitSound("weapons/c4/c4_exp_deb2.wav", 90)
			end
		end)

		return true
	end
}

local function PlayBeep(time, ent)
	timer.Simple(time or 0, function()
		if ent:IsValid() then
			ent:EmitSound("weapons/c4/c4_click.wav", 90)
		end
	end)
end

ITEM.functions.Arm2 = {
	name = "Plant",
	OnRun = function(item)
		local ply = item.player

		local trace = {}
		trace.start = ply:EyePos()
		trace.endpos = trace.start + ply:GetAimVector() * 85
		trace.filter = ply

		local tr = util.TraceLine(trace)
		local ied = ents.Create("prop_physics")
		ied:SetPos(tr.HitPos)
		ied:SetAngles(ply:GetAngles())
		ied:SetModel("models/weapons/w_c4_planted.mdl")
		ied:EmitSound("weapons/c4/c4_disarm.wav", 80)
		ied:PhysicsInit(SOLID_VPHYSICS)
        ied:SetSolid(SOLID_VPHYSICS)
        ied:SetMoveType(MOVETYPE_VPHYSICS)

		local phys = ied:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableMotion(true)
			phys:SetMass(20)
		end
		PlayBeep(0.5, ied)
		PlayBeep(1.5, ied)
		PlayBeep(2.5, ied)
		PlayBeep(3, ied)
		PlayBeep(3.25, ied)
		PlayBeep(3.50, ied)
		PlayBeep(3.75, ied)
		PlayBeep(4, ied)
		PlayBeep(5, ied)
		timer.Simple(5.1, function()
			if ( IsValid(ied) ) then
				local explode = ents.Create("env_explosion")
				explode:SetPos(ied:GetPos())
				explode:SetOwner(ied)
				explode:Spawn()
				explode:SetKeyValue("iMagnitude", "500")
				explode:Fire("explode", "", 0)
				explode:EmitSound("weapons/c4/c4_explode1.wav", 100)
				explode:EmitSound("weapons/c4/c4_exp_deb1.wav", 90)
				explode:EmitSound("weapons/c4/c4_exp_deb2.wav", 90)
				local fire = ents.Create("env_fire")
				fire:SetPos(ied:GetPos())
				fire:Spawn()
				fire:Fire("StartFire")
				local debris = {}

				for i=1,9 do
					local flyer = ents.Create("prop_physics")
					flyer:SetPos(ied:GetPos())

					if i > 4 then
						flyer:SetModel("models/props_debris/wood_chunk08b.mdl")
					else
						flyer:SetModel("models/gibs/metal_gib" .. math.random(1, 5) .. ".mdl")
					end

					flyer:Spawn()
					flyer:Ignite(30)

					local phys = flyer:GetPhysicsObject()

					if phys and IsValid(phys) then
						phys:SetVelocity(Vector(math.random(-150, 150), math.random(-150, 150), math.random(-150, 150)))
					end

					table.insert(debris, flyer)
				end

				timer.Simple(60, function()
					if IsValid(fire) then
						fire:Remove()
					end
				end)

				timer.Simple(40, function()
					for v,k in pairs(debris) do
						if IsValid(k) then
							k:Remove()
						end
					end
				end)

				local effectData = EffectData()
				effectData:SetOrigin(ied:GetPos())
				util.Effect("Explosion", effectData)
			end
		end)
		timer.Simple(5.2, function()
			ied:Remove()
		end)

		local pos = ied:GetPos()

		timer.Simple(1, function()
			for v,k in pairs(ents.FindByClass("prop_ragdoll")) do
				if k:GetPos():DistToSqr(pos) < (1200 ^ 2) then
					k:Ignite(40)
				end
			end
		end)

		return true
	end
}