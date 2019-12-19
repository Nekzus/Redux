function getGuildDefinedRoles(guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local guildData = getGuildData(guild)

	if not guildData then
		client:error("Could not find guildData for guild '%s'", guild.name)
		return false
	end

	local result = {}

	for roleId, roleData in next, guildData:get("roles"):raw() do
		local roleExists = getRole(roleId, "id", guild)
		local guildRoles = guildData:get("roles"):raw()

		if roleExists then
			local isPrimary = getPrimaryRoleIndex(roleData.level, guildRoles) == roleId

			table.insert(result, {
				id = roleId,
				level = roleData.level,
				primary = isPrimary,
				added = roleData.added
			})
		end
	end

	if #result > 1 then
		table.sort(result, function(a, b)
			return a.level > b.level or (a.level == b.level and a.added > b.added)
		end)
	end

	return result
end

return getGuildDefinedRoles
