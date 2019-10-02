function getEmoji(value, key, guild)
	return guild.emojis:find(function(r)
		return r[key] == value
	end)
end

return getEmoji
