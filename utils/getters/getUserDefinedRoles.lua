function getUserDefinedRoles(member, guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
<<<<<<< Updated upstream
	local guildData = getGuildData(guild)

	if not guildData then
		printf("Could not find guildData for guild '%s'", guild.name)

=======
	local member = type(member) == "string" and guild:getMember(member) or member
	local data = getGuildData(guild)

	if not data then
		printf("Could not find data for guild '%s'", guild.name)
>>>>>>> Stashed changes
		return false
	end

	local result = {}

	for obj in member.roles:iter() do
		local roleExists = getRole(obj.id, "id", guild)
		local roles = data:get("roles"):raw()
		local role = roles[obj.id]

		if roleExists and role then
			insert(result, {
				id = obj.id,
				level = role.level,
				primary = getPrimaryRoleIndex(role.level, roles) == roleId,
				added = role.added
			})
		end
	end

	if #result > 1 then
		sort(result, function(a, b)
			return a.level > b.level or (a.level == b.level and a.added > b.added)
		end)
	end

	return result
end

return getUserDefinedRoles
