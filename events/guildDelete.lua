--[[
	Parte responsável por realizar a limpeza para quando uma guilda
	remover	o bot ou o bot sair de uma
]]

client:on("guildDelete",
	function(guild)
		-- Remove os dados referentes à guilda
		for _, data in next, {
			getGuildData(guild),
			getGuildEconomy(guild)
		} do
			data:delete()
		end

		printf("Bot has been removed or left guild %s (%s)", guild.id, guild.name)
	end
)
