ITEM.name = "Civil Protection Acceptance Paper"
ITEM.model = "models/props_c17/paper01.mdl"
ITEM.description = "Civil Protection enlistment paper."
ITEM.category = "Other"
ITEM.noBusiness = true
ITEM.noDrop = true


function ITEM:GetDescription()
	return self.description
end

if (CLIENT) then
    function ITEM:PaintOver(item, w, h)
		ix.util.DrawText("!", w-8, h-19, Color(218,171,3,255), 0, 0, "ixSmallFont")
	end
end

function ITEM:PopulateTooltip(tooltip)
	local data = tooltip:AddRow("data")
	data:SetBackgroundColor(derma.GetColor("Warning", tooltip))
	data:SetText("Bring this paper to the city's local nexus for processing.")
	data:SetFont("DermaDefault")
	data:SetExpensiveShadow(0.5)
	data:SizeToContents()
end