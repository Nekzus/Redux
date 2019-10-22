config.defaultEconomy = {
	symbol = ":dollar:",
	users = {},
	store = {},
	actions = {
		work = {
			cooldown = 30 * config.time.second,
			income = {min = 50, max = 500},
		},
		crime = {
			cooldown = 4 * config.time.minute,
		},
	},
}
