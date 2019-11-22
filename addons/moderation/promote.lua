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

	local user = data.message.mentionedUsers.first
	local member = user and data.guild:getMember(user)

	if not member then
		local text = localize("${userNotFound}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local author = data.member

	if member.highestRole.position >= data.guild.me.highestRole.position
	or member.highestRole.position >= author.highestRole.position then
		local text = localize("${mentionedHigher}", guildLang)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local userRoles = getUserDefinedRoles(member, data.guild)
	local guildRoles = guildData:get("roles"):raw()

	if #userRoles == 0 then
		local roleId

		for i = 0, 3 do
			roleId = getPrimaryRoleIndex(i, guildRoles)

			if roleId then
				break
			end
		end

		local role = roleId and getRole(roleId, "id", data.guild)

		if not role then
			local text = localize("${noDefinedRoleFound}", guildLang)
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

		local text = localize("${userPromoted}", guildLang, member.tag, role.name)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)
		member:addRole(role)

		return true
	else
		local highestRole = userRoles[1]
		local nextRole = getRoleIndexHigherThan(highestRole.level, guildRoles, highestRole.added)

		if not nextRole then
			for i = 1, 5 do
				nextRole = getPrimaryRoleIndex(highestRole.level + i, guildRoles)

				if nextRole then
					break
				end
			end
		end

		if not nextRole then
			local text = localize("${noDefinedRoleFound}", guildLang)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local highestRoleObject = data.guild:getRole(highestRole.id)
		local nextRoleObject = data.guild:getRole(nextRole)

		if not highestRoleObject then
			local text = localize("${roleNotFound}", guildLang, "<highestRoleObject>")
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		elseif not nextRoleObject then
			local text = localize("${roleNotFound}", guildLang, "<nextRoleObject>")
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		elseif highestRole.position == author.highestRole.position then
			local text = localize("${mentionedHigher}", guildLang)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		elseif nextRoleObject.position >= data.guild.me.highestRole.position
		or nextRoleObject.position >= author.highestRole.position then
			local text = localize("${noPromoteEqual}", guildLang)
			local embed = replyEmbed(text, data.message, "warn")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local text = localize("${userPromoted}", guildLang, member.tag, nextRoleObject.name)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)
		member:addRole(nextRoleObject.id)
		member:removeRole(highestRoleObject.id)

		return true
	end
end

return {config = _config, func = _function}
