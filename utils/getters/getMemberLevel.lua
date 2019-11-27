function getMemberLevel(member, guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local data = getGuildData(guild)
	local roles = data:get("roles")
	local resultLevel, resultRole = 0

	member = member.highestRole and member or guild:getMember(member)

	if member.id == client.owner.id then
		resultLevel = config.titles.dev.level
	elseif member.id == guild.owner.id then
		resultLevel = config.titles.owner.level
	end

	for roleId, roleData in next, roles:raw() do
		local role = getRole(roleId, "id", guild)

		if member:hasRole(roleId) then
			if roleData.level > resultLevel then
				resultLevel = roleData.level
				resultRole = role
			end
		end
	end

	return resultLevel, resultRole
end

return getMemberLevel
