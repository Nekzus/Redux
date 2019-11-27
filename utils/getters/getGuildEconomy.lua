function getGuildEconomy(guild, duration)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
<<<<<<< Updated upstream
	local guildData = saves.economy:get(guild.id, config.defaultEconomy)
=======
	local data = db(format("./saves/economy/%s.bin", guild.id), duration)
>>>>>>> Stashed changes

	-- Cria os valores padrões que não estiverem presentes
	for property, value in next, config.defaultEconomy do
		data:get(property, value)
	end

	return data
end

return getGuildEconomy
