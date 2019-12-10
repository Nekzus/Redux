function apiScreenshare(guildId, voiceId)
	assert(guildId, "Missing guild ID")
	assert(voiceId, "Missing voice ID")

	return format(config.apiPoints.discordScreenshare, guildId, voiceId)
end

return apiScreenshare
