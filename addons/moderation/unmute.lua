local _config = {
	name = "unmute",
	desc = "${unmutesUser}",
	usage = "${userKey}",
	aliases = {"umt", "unmt"},
	cooldown = 0,
	level = 1,
	direct = false,
	perms = {"manageRoles"},
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

	local roleId = getPrimaryRoleIndex(-1, guildData:get("roles"):raw())
	local role = roleId and getRole(roleId, "id", data.guild)

	if not role then
		local text = parseFormat("${muteRoleNotFound}; ${mutedRoleTip}", langList, data.prefix)
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

	local unmutedUsers = ""
	local alreadyUnmutedUsers = ""

	local unmutedAmount = 0
	local alreadyUnmutedAmount = 0

	for _, user in next, data.message.mentionedUsers:toArray() do
		local member = user and data.guild:getMember(user)
		local muteData = guildData:get("mutes"):raw()[member.id]
		local canUnmute = true

		if not muteData then
			if alreadyUnmutedUsers ~= "" then
				alreadyUnmutedUsers = format("%s, ", alreadyUnmutedUsers)
			end

			alreadyUnmutedAmount = alreadyUnmutedAmount + 1
			alreadyUnmutedUsers = format("%s%s", alreadyUnmutedUsers, member.name)
		else
			local tempMutes = saves.temp:get("mutes")
			local timerProcess = muteTimers[muteData.guid]

			if timerProcess then
				timerProcess:stop()
				timerProcess:close()
			end

			guildData:get("mutes"):set(member.id, nil)
			tempMutes:set(muteData.guid, nil)

			if role and member:hasRole(roleId) then
				member:removeRole(role)
			end

			if unmutedUsers ~= "" then
				unmutedUsers = format("%s, ", unmutedUsers)
			end

			unmutedAmount = unmutedAmount + 1
			unmutedUsers = format("%s%s", unmutedUsers, member.name)
		end
	end

	local text = ""

	if unmutedAmount > 0 then
		if text ~= "" then
			text = format("%s\n", text)
		end

		if unmutedAmount == 1 then
			text = format("%s%s", text, parseFormat("${followingUserBeenUnmuted}", langList, unmutedUsers))
		else
			text = format("%s%s", text, parseFormat("${followingUsersBeenUnmuted}", langList, unmutedUsers))
		end
	end

	if alreadyUnmutedAmount > 0 then
		if text ~= "" then
			text = format("%s\n", text)
		end

		if alreadyUnmutedAmount == 1 then
			text = format("%s%s", text, parseFormat("${followingUserNotMuted}", langList, alreadyUnmutedUsers))
		else
			text = format("%s%s", text, parseFormat("${followingUsersNotMuted}", langList, alreadyUnmutedUsers))
		end
	end

	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
