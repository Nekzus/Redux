function getUserDefinedRoles(member, guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local member = type(member) == "string" and guild:getMember(member) or member
	local guildData = getGuildData(guild)

	if not guildData then
		client:error("Could not find guildData for guild '%s'", guild.name)
		return false
	end

	local result = {}

	for obj in member.roles:iter() do
		local roleExists = getRole(obj.id, "id", guild)
		local guildRoles = guildData:get("roles"):raw()
		local guildRole = guildRoles[obj.id]

		if roleExists and guildRole then
			local isPrimary = getPrimaryRoleIndex(guildRole.level, guildRoles) == roleId

			table.insert(result, {
				id = obj.id,
				level = guildRole.level,
				primary = isPrimary,
				added = guildRole.added
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

return getUserDefinedRoles
