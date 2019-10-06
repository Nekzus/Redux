function getRole(value, key, guild)
	if not (guild and guild.roles) then
		print("Invalid guild object passed on getRole()")
		return nil
	end

	return guild.roles:find(function(r)
		return r[key] == value
	end)
end

return getRole
