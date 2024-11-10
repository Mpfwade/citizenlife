RECIPE.name = "Bandage"
RECIPE.description = "Craft some bandages with 2 pieces of cloth."
RECIPE.model = "models/willardnetworks/skills/bandaid.mdl"
RECIPE.category = "Medical Items"

RECIPE.base = "recipe_base"


RECIPE:PostHook("OnCanCraft", function(self, ply)
    for _, v in pairs(ents.FindByClass( self.station )) do
        if ply:GetPos():DistToSqr(v:GetPos()) < 100 * 100 then
            if ply.isCrafting == true then return false, "You cannot make multiple items while you are making something else!" end
            ply.benchInUse = v

            return true
        end
    end

    return false, "You need to be near a station."
end)

RECIPE.requirements = {
	["cloth"] = 2,
}
RECIPE.results = {
	["bandage"] = 1,
}

RECIPE.station = "ix_workbench"
RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 3
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"