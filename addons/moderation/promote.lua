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

	local author = data.guild:getMember(data.author)

	if member.highestRole.position >= data.guild.me.highestRole.position
	or member.highestRole.position >= author.highestRole.position then
		local text = localize("${mentionedHigher}", guildLang)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)
		return
	end

	local userRoles = getUserDefinedRoles(member, data.guild)
	local guildRoles = guildData:get("roles"):raw()

	if #userRoles > 0 then
		local highestRole = userRoles[1]
		local nextRoleId = getRoleIndexHigherThan(highestRole.level, guildRoles, highestRole.added)

		if not nextRoleId then
			for i = 1, 5 do
				nextRoleId = getPrimaryRoleIndex(highestRole.level + i, guildRoles)

				if nextRoleId then
					break
				end
			end
		end

		if nextRoleId then
			local currentRole = data.guild:getRole(highestRole.id)
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
			elseif highestRole.position == author.highestRole.position then
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

				local text = localize("${userPromoted}", guildLang, member.tag, nextRole.name)
				local embed = replyEmbed(text, data.message, "ok")

				bird:post(nil, embed:raw(), data.channel)
				member:addRole(nextRole.id)
				member:removeRole(currentRole.id)
				return true
			else
				local text = localize("${cannotPromoteUser}", guildLang, member.tag)
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
				local text = localize("${userPromoted}", guildLang, data.prefix, role.name)
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

			local text = localize("${userModed}", guildLang, member.tag)
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)
			member:addRole(role)
			return true
		end
	end

	return {config = _config, func = _function}
