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
	local private = data.targetMember == nil
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

	local author = data.guild:getMember(data.author)

	if targetMember.highestRole.position >= data.guild.me.highestRole.position
	or targetMember.highestRole.position >= author.highestRole.position then
		local text = localize("${mentionedHigher}", guildLang)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)
		return
	end

	local targetRoles = getUserDefinedRoles(targetMember, data.guild)
	local guildRoles = guildData:get("roles"):raw()

	if #targetRoles > 0 then
		local currentRoleData = targetRoles[1]
		local nextRoleId = getRoleIndexHigherThan(currentRoleData.level, guildRoles, currentRoleData.added)

		if not nextRoleId then
			for i = 1, 5 do
				nextRoleId = getPrimaryRoleIndex(currentRoleData.level + i, guildRoles)

				if nextRoleId then
					break
				end
			end
		end

		if nextRoleId then
			local currentRole = data.guild:getRole(currentRoleData.id)
			local nextRole = data.guild:getRole(nextRoleId)

			if not currentRole then
				local text = localize("${roleNotFound}", guildLang, "<currentRole>")
				local embed = replyEmbed(text, data.message, "error")

				bird:post(nil, embed:raw(), data.channel)
				return false
			elseif not nextRole then
				local text = localize("${roleNotFound}", guildLang, "<nextRole>")
				local embed = replyEmbed(text, data.message, "error")

				bird:post(nil, embed:raw(), data.channel)
				return false
			elseif currentRole.position == author.highestRole.position then
				local text = localize("${mentionedHigher}", guildLang)
				local embed = replyEmbed(text, data.message, "error")

				bird:post(nil, embed:raw(), data.channel)
				return false
			elseif nextRole.position >= data.guild.me.highestRole.position
			or nextRole.position >= author.highestRole.position then
				local text = localize("${noPromoteEqual}", guildLang)
				local embed = replyEmbed(text, data.message, "warn")

				bird:post(nil, embed:raw(), data.channel)
				return false
			end

			local text = localize("${userPromoted}", guildLang, targetMember.tag, nextRole.name)
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)
			targetMember:addRole(nextRole.id)
			targetMember:removeRole(currentRole.id)
			return true
		else
			local text = localize("${cannotPromoteUser}", guildLang, targetMember.tag)
			local embed = replyEmbed(text, data.message, "warn")

			bird:post(nil, embed:raw(), data.channel)
			return false
		end
	else
		local roleId

		for i = 0, 3 do
			roleId = getPrimaryRoleIndex(i, guildRoles)

			if roleId then
				break
			end
		end

		local role = roleId and getRole(roleId, "id", data.guild)

		if not role then
			local text = localize("${roleNotFound}", guildLang, "<nextRole>")
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)
			return false
		end

		if role.position >= data.guild.me.highestRole.position then
			local text = localize("${roleSelectedHigher}", guildLang, role.name)
			local embed = replyEmbed(text, data.message, "warn")

			bird:post(nil, embed:raw(), data.channel)
			return false
		end

		local text = localize("${userPromoted}", guildLang, targetMember.tag, role.name)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)
		targetMember:addRole(role)
		return true
	end
end

return {config = _config, func = _function}
