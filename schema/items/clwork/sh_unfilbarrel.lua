ITEM.name = "Unfiltered Barrel"
ITEM.description = "Water processing product, contains drained water and whatever else the machine sucked up."
ITEM.model = "models/props_borealis/bluebarrel001.mdl"
ITEM.category = "Tools"
ITEM.width = 1
ITEM.height = 1

function ITEM:OnEntityCreated(entity)
    if IsValid(entity) then
        -- Set the item ID on the entity explicitly
        entity:SetNetVar("id", self.id)
        print("Set NetVar 'id' on entity:", entity, "ID:", self.id)
    end
end