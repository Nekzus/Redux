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
	local langData = langs[guildLang]
	local args = data.args

	if not specifiesUser(data.message) then
		local text = parseFormat("${specifyUser}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsOwner(data.message) then
		local text = parseFormat("${noExecuteOwner}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsBot(data.message) then
		local text = parseFormat("${noExecuteBot}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsSelf(data.message) then
		local text = parseFormat("${noExecuteSelf}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local roleId = getPrimaryRoleIndex(-1, guildData:get("roles"):raw())
	local role = roleId and getRole(roleId, "id", data.guild)

	if not role then
		local text = parseFormat("${muteRoleNotFound}; ${mutedRoleTip}", langData, data.prefix)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	if role.position >= data.guild.me.highestRole.position then
		local text = parseFormat("${roleSelectedHigher}", langData, role.name)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local unmuted = {}
	local alreadyUnmuted = {}

	for _, user in next, data.message.mentionedUsers:toArray() do
		local member = user and data.guild:getMember(user)
		local muteData = guildData:get("mutes"):raw()[member.id]
		local canUnmute = true

		if not muteData then
			insert(alreadyUnmuted, member.name)
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

			insert(unmuted, member.name)
		end
	end

	local text = ""

	if #unmuted > 0 then
		text = text ~= "" and format("%s\n", text) or text
		text = format(
			"%s%s",
			text,
			parseFormat(
				(#unmuted == 1 and "${followingUserBeenUnmuted}") or "${followingUsersBeenUnmuted}",
				langData, concat(unmuted, ", ")
			)
		)
	end

	if #alreadyUnmuted > 0 then
		text = text ~= "" and format("%s\n", text) or text
		text = format(
			"%s%s",
			text,
			parseFormat(
				(#alreadyUnmuted == 1 and "${followingUserNotMuted}") or "${followingUsersNotMuted}",
				langData, concat(alreadyUnmuted, ", ")
			)
		)
	end

	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
