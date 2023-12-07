ix.config.Add("maxWeight", 6, "The maximum weight in Kilograms someone can carry in their inventory.", nil, {
	data = {
		min = 1,
		max = 100
	},
	category = "Weight"
})

ix.config.Add("maxOverWeight", 30, "The maximum amount of weight in Kilograms they can go over their weight limit, this should be less than maxWeight to prevent issues.", nil, {
	data = {
		min = 1,
		max = 100
	},
	category = "Weight"
})