function getGuildEconomy(guild)
	local guildId = (type(guild) == "string" and guild) or (type(guild) == "table" and guild.id)
	local guildData = saves.economy:get(guildId, config.economyDefault)

	for k, v in next, config.economyDefault do
		guildData:get(k, v)
	end

	return guildData
end

return getGuildEconomy
