local _config = {
	name = "demote",
	desc = "${demotesUser}",
	usage = "${userKey}",
	aliases = {"de", "dem"},
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

	if member.highestRole.position == author.highestRole.position then
		local text = parseFormat("${noDemoteEqual}", langList)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

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
		local nextRole = getRoleIndexLowerThan(highestRole.level, guildRoles, highestRole.added)

		if not nextRole then
			for i = 1, 5 do
				nextRole = getHighestRoleIndex(math.max(0, highestRole.level - i), guildRoles)

				if nextRole then
					break
				end
			end
		end

		local highestRoleObject = data.guild:getRole(highestRole.id)
		local nextRoleObject = data.guild:getRole(nextRole)

		if not highestRoleObject then
			local text = parseFormat("${roleNotFound}", langList, "<highestRoleObject>")
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local text = parseFormat("${userDemoted}", langList, member.tag, (nextRoleObject and nextRoleObject.name) or (parseFormat("${member}", langList)))
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		if nextRole then
			member:addRole(nextRoleObject.id)
		end

		member:removeRole(highestRoleObject.id)

		return true
	end
end

return {config = _config, func = _function}
