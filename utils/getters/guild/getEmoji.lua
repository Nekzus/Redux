function getEmoji(value, key, guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild

	return guild.emojis:find(function(role)
		return role[key] == value
	end)
end

return getEmoji
