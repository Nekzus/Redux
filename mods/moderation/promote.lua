local _config = {
	name = "promote",
	desc = "${promotesUser}",
	usage = "${userKey}",
	aliases = {"pro", "prom"},
	cooldown = 0,
	level = 2,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	if not specifiesUser(data.message) then
		local text = parseFormat("${specifyUser}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsOwner(data.message) then
		local text = parseFormat("${noExecuteOwner}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsBot(data.message) then
		local text = parseFormat("${noExecuteBot}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsSelf(data.message) then
		local text = parseFormat("${noExecuteSelf}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local user = data.message.mentionedUsers.first
	local member = user and data.guild:getMember(user)

	if not user or not member then
		local text = parseFormat("${userNotFound}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local author = data.guild:getMember(data.author)

	if member.highestRole.position >= data.guild.me.highestRole.position
	or member.highestRole.position >= author.highestRole.position then
		local text = parseFormat("${mentionedHigher}", langList)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return
	end

	local userRoles = getUserDefinedRoles(member, data.guild)
	local guildRoles = guildData:get("roles"):raw()

	if #userRoles > 0 then
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

		if nextRole then
			local highestRoleObject = data.guild:getRole(highestRole.id)
			local nextRoleObject = data.guild:getRole(nextRole)

			if not highestRoleObject then
				local text = parseFormat("${roleNotFound}", langList, "<highestRoleObject>")
				local embed = replyEmbed(text, data.message, "error")

				bird:post(nil, embed:raw(), data.channel)

				return false
			elseif not nextRoleObject then
				local text = parseFormat("${roleNotFound}", langList, "<nextRoleObject>")
				local embed = replyEmbed(text, data.message, "error")

				bird:post(nil, embed:raw(), data.channel)

				return false
			elseif highestRole.position == author.highestRole.position then
				local text = parseFormat("${mentionedHigher}", langList)
				local embed = replyEmbed(text, data.message, "error")

				bird:post(nil, embed:raw(), data.channel)

				return false
			elseif nextRoleObject.position >= data.guild.me.highestRole.position
				or nextRoleObject.position >= author.highestRole.position then
					local text = parseFormat("${noPromoteEqual}", langList)
					local embed = replyEmbed(text, data.message, "warn")

					bird:post(nil, embed:raw(), data.channel)

					return false
				end

				local text = parseFormat("${userPromoted}", langList, member.tag, nextRoleObject.name)
				local embed = replyEmbed(text, data.message, "ok")

				-- this gives the user the "feel" of no lag whilst promoting
				bird:post(nil, embed:raw(), data.channel)
				member:addRole(nextRoleObject.id)
				member:removeRole(highestRoleObject.id)

				return true
			else
				local text = parseFormat("${cannotPromoteUser}", langList, member.tag)
				local embed = replyEmbed(text, data.message, "warn")

				bird:post(nil, embed:raw(), data.channel)

				return false
			end
		else
			local guildRoles = guildData:get("roles"):raw()
			local roleId = getPrimaryRoleIndex(1, guildRoles)
			local role = roleId and getRole(roleId, "id", data.guild)

			if not role then
				local text = parseFormat("${modRoleNotFound}; ${modRoleTip}", langList, data.prefix)
				local embed = replyEmbed(text, data.message, "error")

				bird:post(nil, embed:raw(), data.channel)

				return false
			end

			if role.position >= data.guild.me.highestRole.position then
				local text = parseFormat("${roleSelectedHigher}", langList, role.name)
				local embed = replyEmbed(text, data.message, "warn")

				bird:post(nil, embed:raw(), data.channel)

				return false
			end

			local text = parseFormat("${userModed}", langList, member.tag)
			local embed = replyEmbed(text, data.message, "ok")

			-- this gives the user the "feel" of no lag whilst promoting
			bird:post(nil, embed:raw(), data.channel)
			member:addRole(role)

			return true
		end
	end

	return {config = _config, func = _function}
