function getGuildEconomy(guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local guildData = saves.economy:get(guild.id, config.defaultEconomy)

	for property, value in next, config.defaultEconomy do
		guildData:get(property, value)
	end

	return guildData
end

return getGuildEconomy
