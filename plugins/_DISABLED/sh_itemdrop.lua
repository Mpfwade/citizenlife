local PLUGIN = PLUGIN

function PLUGIN:PlayerInteractItem(client, action, item)
    local dropAnim = "ThrowItem"
    local bool = true


    if action == "drop" then
        client:ForceSequence(dropAnim, nil, 1, bNoFreeze)
    end
end