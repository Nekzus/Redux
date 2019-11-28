--[[
	Parte responsável por realizar a limpeza para quando uma guilda
	remover	o bot ou o bot sair de uma
]]

client:on("guildDelete",
	function(guild)
		-- Remove os dados referentes à guilda
		getGuildData(guild.id):delete()
		getGuildEconomy(guild.id):delete()

		printf("Bot has been removed or left guild %s (%s)", guild.id, guild.name)
	end
)
