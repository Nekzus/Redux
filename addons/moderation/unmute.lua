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

	local roleId = getPrimaryRoleIndex(-1, guildData:get("roles"):raw())
	local role = roleId and getRole(roleId, "id", data.guild)

	if not role then
		local text = localize("${muteRoleNotFound}; ${mutedRoleTip}", guildLang, data.prefix)
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

	local unmuted = {}
	local alreadyUnmuted = {}

	for _, user in next, data.message.mentionedUsers:toArray() do
		local member = user and data.guild:getMember(user)
		local canUnmute = true

		if not member then
			canUnmute = false
			table.insert(alreadyUnmuted, member.name)
		end

		local tempMutes = saves.temp:get("mutes")
		local guildMutes = guildData:get("mutes")
		local guildMute = guildMutes:raw()[member.id]
		local tempMute = guildMute and tempMutes:raw(guildMute.guid)

		if not (guildMute and tempMute) then
			table.insert(alreadyUnmuted, member.name)
		else
			local process = bot.muteTimers[guildMute.guid]

			if process and not process:is_closing() then
				process:close()
				process = nil
			end

			tempMutes:set(guildMute.guid, nil)
			guildMutes:set(member.id, nil)

			saves.temp:save()
			guildData:save()

			if role and member:hasRole(role) then
				member:removeRole(role)
			end

			table.insert(unmuted, member.name)
		end
	end

	local text = ""

	if #unmuted > 0 then
		text = text ~= "" and string.format("%s\n", text) or text
		text = string.format(
			"%s%s",
			text,
			localize(
				(#unmuted == 1 and "${followingUserBeenUnmuted}") or "${followingUsersBeenUnmuted}",
				guildLang, table.concat(unmuted, ", ")
			)
		)
	end

	if #alreadyUnmuted > 0 then
		text = text ~= "" and string.format("%s\n", text) or text
		text = string.format(
			"%s%s",
			text,
			localize(
				(#alreadyUnmuted == 1 and "${followingUserNotMuted}") or "${followingUsersNotMuted}",
				guildLang, table.concat(alreadyUnmuted, ", ")
			)
		)
	end

	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
