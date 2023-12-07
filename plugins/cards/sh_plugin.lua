PLUGIN.name = "Playing Cards"
PLUGIN.author = "Shooter"

ix.command.Add("draw", {
    description = 'Pull a playing card from the deck.',
	OnRun = function(self, client)
		local inventory = client:GetCharacter():GetInventory()
		if (!inventory:HasItem("playingcards")) then
			client:Notify("You do not have a playing cards deck.")
			client:EmitSound("physics/cardboard/cardboard_box_impact_bullet1.wav")
			return
		end

		local family = {"Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King",}
		local fam2 = {"Hearts", "Diamonds", "Clubs", "Spades",}
		
		local msg = "draws " ..table.Random(family).. " of " ..table.Random(fam2)
		
		ix.chat.Send(client, "me", msg)
	end
})