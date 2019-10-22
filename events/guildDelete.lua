client:on("guildDelete",
	function(guild)
		saves.global:set(guild.id, nil)
		saves.economy:set(guild.id, nil)

		printf("[Guild Removed] Purged all data from guild %s (%s)", guild.id, guild.name)
	end
)
