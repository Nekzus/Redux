--[[
	Parte responsável por realizar checagens quando um usuário novo
	entrar em uma guilda
]]

client:on("memberJoin",
	function(member)
		if member.user.bot then
			return
		end

		local guild = member.guild
		local guildData = getGuildData(guild)
		local muteData = guildData:get("mutes"):raw()[member.id]
		local autoRoleId = getPrimaryRoleIndex(0, guildData:get("roles"):raw())
		local autoRole = roleId and getRole(autoRoleId, "id", guild)

		if autoRole and not member:hasRole(autoRole) then
			member:addedRole(autoRole)
		end

		-- Verifica se o usuário que entrou estava mutado (ocorre quando um
		-- usuário mutado sai da guilda e re-entra para perder o cargo)
		if muteData and hasPermissions(member, nil, {"manageRoles"}) then
			local roleId = getPrimaryRoleIndex(-1, guildData:get("roles"):raw())
			local role = roleId and getRole(roleId, "id", guild)

			if role and not member:hasRole(role) then
				member:addRole(role)
			end
		end
	end
)
