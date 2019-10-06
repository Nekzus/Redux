function getGuildEconomy(guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local guildData = saves.economy:get(guild.id, config.economyDefault)

	for k, v in next, config.economyDefault do
		guildData:get(k, v)
	end

	return guildData
end

return getGuildEconomy
