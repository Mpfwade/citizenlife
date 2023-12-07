function PLUGIN:PopulateItemTooltip(tooltip, item)
    local weight = item:GetWeight()

    if weight then
        local row = tooltip:AddRowAfter("description", "weight")
        row:SetText(ix.weight.WeightString(weight, ix.option.Get("imperial", false)))
        row:SetExpensiveShadow(1, color_black)
        row:DockMargin(5, 0, 5, 0)
        row:SizeToContents()
    end
end

ix.option.Add("imperial", ix.type.bool, false, {
    category = "Weight"
})