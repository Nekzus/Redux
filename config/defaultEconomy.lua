-- Modelo padrão de economia das guildas

config.defaultEconomy = {
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
