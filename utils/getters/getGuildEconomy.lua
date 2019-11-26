function getGuildEconomy(guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local guildData = saves.economy:get(guild.id, config.defaultEconomy) --ndb(format("./test/economy/%s.bin", guild.id))

	for property, value in next, config.defaultEconomy do
		guildData:get(property, value)
	end

	return guildData
end

return getGuildEconomy
