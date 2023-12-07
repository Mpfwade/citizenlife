ix.command.Add("datapad", {
	description = "A datapad that shows info on all citizens.",
	OnRun = function(self, client)
		if !client:IsCombine() then
			return "You need to be a combine to use this command!"
		end

		netstream.Start(client, "OpenDataMenu", {})
	end;
})