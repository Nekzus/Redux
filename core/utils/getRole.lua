function getRole(value, key, guild)
	return guild.roles:find(function(r)
		return r[key] == value
	end)
end

return getRole
