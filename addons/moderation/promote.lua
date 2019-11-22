local _config = {
	name = "promote",
	desc = "${promotesUser}",
	usage = "${userKey}",
	aliases = {"pro", "prom"},
	cooldown = 0,
	level = 2,
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

	if targetMember.highestRole.position >= data.guild.me.highestRole.position
	or targetMember.highestRole.position >= member.highestRole.position then
		local text = localize("${mentionedHigher}", guildLang)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local userRoles = getUserDefinedRoles(targetMember, data.guild)
	local guildRoles = guildData:get("roles"):raw()
	local userRoleData = userRoles[1] -- Retorna o cargo mais alto definido atualmente que o usuário tem
	local userRole = userRoleData and data.guild:getRole(userRoleData.id)
	local nextRole

	-- Caso o usuário já tiver um cargo, teremos que subir ele de nível
	if userRoleData then
		local nextRoleId = getRoleIndexHigherThan(userRoleData.level, guildRoles, userRoleData.added)

		-- Procura pelo primeiro cargo do próximo nível
		if not nextRoleId then
			for i = 1, 5 do
				nextRoleId = getPrimaryRoleIndex(userRoleData.level + i, guildRoles)

				if nextRoleId then
					break
				end
			end
		end

		nextRole = nextRoleId and data.guild:getRole(nextRoleId)
	else

	end
end

return {config = _config, func = _function}
