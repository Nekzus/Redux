config.templates = {
	guild = {
		prefix = ".",
		lang = "en-us",
	},
	
	economy = {
		symbol = ":dollar:",
		users = {},
		store = {},
		actions = {
			work = {
				cooldown = 30 * timeUnit.second,
				income = {min = 50, max = 500},
			},
		},
	}
}
