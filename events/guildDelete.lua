client:on("guildDelete",
	function(guild)
		for _, data in next, {
			getGuildData(guild),
			getGuildEconomy(guild)
		} do
			data:delete()
		end

		client:info("Bot left or was removed from guild %s (%s)", guild.id, guild.name)
	end
)
