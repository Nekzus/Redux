client:on("memberJoin",
	function(member)
		if member.user.bot then
			return
		end

		local guild = member.guild
		local guildData = getGuildData(guild)
		local muteData = guildData:get("mutes"):raw()[member.id]

		if muteData and hasPermissions(member, nil, {"manageRoles"}) then
			local roleId = getPrimaryRoleIndex(-1, guildData:get("roles"):raw())
			local role = roleId and getRole(roleId, "id", guild)

			if role and not member:hasRole(role) then
				member:addRole(role)
			end
		end

		local memberRoleId = getPrimaryRoleIndex(0, guildData:get("roles"):raw())
		local memberRole = memberRoleId and getRole(memberRoleId, "id", guild)

		if memberRole then
			member:addRole(memberRole)
		end
	end
)
