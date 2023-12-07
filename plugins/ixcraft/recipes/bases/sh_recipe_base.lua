RECIPE.name = "Recipe Base"
RECIPE.description = "N/A"
RECIPE.model = "models/Items/BoxMRounds.mdl"
RECIPE.category = "Misc"
RECIPE.isBase = true
RECIPE.requirements = {}
RECIPE.results = {}

RECIPE.station = "ix_workbench" or "ix_cookstation"

RECIPE.craftStartSound = "physics/metal/weapon_impact_hard2.wav"
RECIPE.craftEndSound = "physics/metal/weapon_impact_hard3.wav"
RECIPE.craftTime = nil

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

if SERVER then
    RECIPE:PostHook("OnCraft", function(self, ply)
        local ent = ply.benchInUse
        if not ent or not IsValid(ent) then return end

        if ply.isCrafting == true then
            ply.isCrafting = true
            ply:EmitSound(self.craftStartEnd or "")
            ply:SetAction("Making " .. self.name .. "...", self.craftTime or 5)

            ply:DoStaredAction(ent, function()
                ply.isCrafting = nil
                ply:Notify("You successfully made a " .. self.name .. "." or "You successfully made a item.")
                ply:EmitSound(self.craftEndSound or "")

                return true
            end, self.craftTime or 5, function()
                ply:SetAction(nil)
                ply.isCrafting = nil
            end)
        else
            return
        end

        ply.benchInUse = nil
    end)
end