function getGuildEconomy(guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local data = db(format("./saves/economy/%s.bin", guild.id))

	-- Cria os valores padrões que não estiverem presentes
	for property, value in next, config.defaultEconomy do
		data:get(property, value)
	end

	return data
end

return getGuildEconomy
