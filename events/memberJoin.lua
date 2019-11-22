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

		-- Verifica se o usuário que entrou estava mutado (ocorre quando um
		-- usuário mutado sai da guilda e re-entra para perder o cargo)
		if muteData and hasPermissions(member, nil, {"manageRoles"}) then
			local roleId = getPrimaryRoleIndex(-1, guildData:get("roles"):raw())
			local role = roleId and getRole(roleId, "id", guild)

			if role and not member:hasRole(role) then
				member:addRole(role)
			end
		end

		-- Adiciona o cargo automático ao usuário caso ele estiver configurado
		local memberRoleId = getPrimaryRoleIndex(0, guildData:get("roles"):raw())
		local memberRole = memberRoleId and getRole(memberRoleId, "id", guild)

		if memberRole then
			member:addRole(memberRole)
		end
	end
)
