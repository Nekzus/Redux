function getLoadingEmoji()
	return getEmoji(config.emojis.loading, "name", baseGuild).mentionString
end

return getLoadingEmoji
