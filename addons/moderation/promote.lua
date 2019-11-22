local _config = {
	name = "promote",
	desc = "${promotesUser}",
	usage = "${userKey}",
	aliases = {"pro", "prom"},
	cooldown = 0,
	level = 5, -- 2
	direct = false,
	perms = {"manageRoles"},
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	if not specifiesUser(data.message) then
		local text = localize("${specifyUser}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false
	elseif mentionsOwner(data.message) then
		local text = localize("${noExecuteOwner}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false
	elseif mentionsBot(data.message) then
		local text = localize("${noExecuteBot}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false
	elseif mentionsSelf(data.message) then
		local text = localize("${noExecuteSelf}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false
	end

	local targetUser = data.message.mentionedUsers.first
	local targetMember = targetUser and data.guild:getMember(targetUser)

	if not targetMember then
		local text = localize("${userNotFound}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local member = data.member

	-- Verifica se o usuário alvo tem o mesmo cargo que o usuário que está
	-- executando o comando, isso é necessário pois dentro dos limites que foram
	-- definidos por nossa hierarquia, um usuário não pode promover alguém com
	-- os mesmos níveis de permissão
	if targetMember.highestRole.position == member.highestRole.position then
		local text = localize("${noDemoteEqual}", guildLang)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	-- Verifica se o usuário alvo está acima do bot ou do usuário que está
	-- chamando o comando
	elseif targetMember.highestRole.position >= data.guild.me.highestRole.position
	or targetMember.highestRole.position >= member.highestRole.position then
		local text = localize("${mentionedHigher}", guildLang)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	-- Registra as variáveis relevantes do usuário
	local userRoles = getUserDefinedRoles(targetMember, data.guild)
	local guildRoles = guildData:get("roles"):raw()
	local userRoleData = userRoles[1] -- Retorna o cargo mais alto definido atualmente que o usuário tem
	local userRole = userRoleData and data.guild:getRole(userRoleData.id)
	local nextRoleId
	local nextRole

	-- Caso o usuário já tiver um cargo, teremos que subir ele de nível
	if userRoleData then
		-- Procura pelo cargo que está acima do atual do usuário
		nextRoleId = getRoleIndexHigherThan(userRoleData.level, guildRoles, userRoleData.added)

		-- Procura pelo primeiro cargo do próximo nível à partir do cargo que
		-- o usuário está atualmente
		if not nextRoleId then
			for i = 1, 3 do
				nextRoleId = getPrimaryRoleIndex(userRoleData.level + i, guildRoles)

				if nextRoleId then
					break
				end
			end
		end
	else
		-- Procura pelo primeiro cargo dentre os que podem estar disponíveis
		for i = 0, 3 do
			nextRoleId = getPrimaryRoleIndex(i, guildRoles)

			if nextRoleId then
				break
			end
		end
	end

	-- Registra o objeto do cargo
	if nextRoleId then
		nextRole = data.guild:getRole(nextRoleId)
	else
		local text = localize("${roleNotFound}", guildLang, "<nextRole>")
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local text = localize("${userPromoted}", guildLang, member.tag, nextRole.name)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)
	targetMember:addRole(nextRole)
	if userRole then
		targetMember:removeRole(userRole)
	end

	return true
end

return {config = _config, func = _function}
