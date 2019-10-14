function getGuildEconomy(guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local guildData = saves.economy:get(guild.id, config.economyDefault)

	for property, value in next, config.economyDefault do
		guildData:get(property, value)
	end

	return guildData
end

return getGuildEconomy
