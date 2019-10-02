function getTextChannel(value, key, guild)
	return guild.textChannels:find(function(r)
		return r[key] == value
	end)
end

return getTextChannel
