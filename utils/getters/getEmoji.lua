function getEmoji(value, key, guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild

	return guild.emojis:find(function(r)
		return r[key] == value
	end)
end

return getEmoji
