--[[
	Parte responsável por realizar a limpeza para quando uma guilda
	remover	o bot ou o bot sair de uma
]]

client:on("guildDelete",
	function(guild)
		-- Remove os dados referentes à guilda
		local guildData = getGuildData(guild.id)

		if guildData then
			guildData:delete()
		end

		local guildEconomy = getGuildEconomy(guild.id)

		if guildData then
			guildEconomy:delete()
		end

		printf("Bot has been removed or left guild %s (%s)", guild.id, guild.name)
	end
)
