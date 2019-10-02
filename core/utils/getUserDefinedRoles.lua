function getUserDefinedRoles(member, guild)
	local guildData = getGuildData(guild)

	if not guildData then
		printf("Could not find guildData for guild '%s'", guild.name)

		return false
	end

	local ret = {}

	for obj in member.roles:iter() do
		local roleExists = getRole(obj.id, "id", guild)
		local guildRoles = guildData:get("roles"):raw()
		local guildRole = guildRoles[obj.id]

		if roleExists and guildRole then
			local isPrimary = getPrimaryRoleIndex(guildRole.level, guildRoles) == roleId

			insert(ret, {id = obj.id, level = guildRole.level, primary = isPrimary, added = guildRole.added})
		end
	end

	if #ret > 1 then
		sort(ret, function(a, b)
			return a.level > b.level or (a.level == b.level and a.added > b.added)
		end)
	end

	return ret
end

return getUserDefinedRoles
