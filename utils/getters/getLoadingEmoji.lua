function getLoadingEmoji()
	return getEmoji(config.emojis.loading, "name", baseGuildId).mentionString
end

return getLoadingEmoji
