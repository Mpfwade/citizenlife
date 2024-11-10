--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

netstream.Hook("ixViewData", function(target, cid, data)
	if(!target) then
		return
	end

	ix.gui.record = vgui.Create("ixCombineViewData")
	ix.gui.record:Build(target, cid, data)
end)

netstream.Hook("OpenDataMenu", function(data)
	vgui.Create("ixMPFTerminal")
end)