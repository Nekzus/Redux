function getMembersFromRole(guild, role)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local role = type(role) == "string" and guild:getRole(role) or role

	return role.members:toArray()
end

return getMembersFromRole
