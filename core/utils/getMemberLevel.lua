function getMemberLevel(member, guild)
	local guildData = getGuildData(guild)
	local guildRoles = guildData:get("roles")

	local rLevel, rRole = 0

	member = member.highestRole and member or guild:getMember(member)

	if member.id == client.owner.id then
		rLevel = config.titles.dev.level
	elseif member.id == guild.owner.id then
		rLevel = config.titles.owner.level
	end

	for roleId, roleData in next, guildRoles:raw() do
		local role = getRole(roleId, "id", guild)

		if member:hasRole(roleId) then
			if roleData.level > rLevel then
				rLevel = roleData.level
				rRole = role
			end
		end
	end

	return rLevel, rRole
end

return getMemberLevel
