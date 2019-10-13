function apiScreenshare(guildId, voiceId)
	assert(guildId, "Missing guild ID")
	assert(voiceId, "Missing voice ID")

	return format(api.discordScreenshare, guildId, voiceId)
end

return apiScreenshare
