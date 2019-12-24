local _config = {
	name = "mute",
	desc = "${mutesUser}",
	usage = "${userKey} ${numKey} \"${reasonKey}\"",
	aliases = {"mt"},
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

	local muted = {}
	local notMuted = {}
	local alreadyMuted = {}

	local content = data.content
	local muteTime = content:match("%s%d+%a") or content:match("%s%d+")

	muteTime = muteTime
	and math.clamp(interpTime(muteTime), timeUnit.second * 5, timeUnit.month)
	or timeUnit.hour

	local formalMuteTime = localize(timeLong(muteTime), guildLang)
	local reason = data.content:match(config.patterns.quotes.capture)

	for _, user in next, data.message.mentionedUsers:toArray() do
		local member = user and data.guild:getMember(user.id)
		local canMute = true

		if not member then
			canMute = false
			table.insert(notMuted, member.name)
		end

		local tempMutes = saves.temp:get("mutes")
		local guildMutes = guildData:get("mutes")
		local guildMute = guildMutes:raw()[member.id]

		if guildMute then
			if tempMutes:raw()[member.id]
			or guildMutes:raw()[member.id]
			or member:hasRole(role) then
				canMute = false
				table.insert(alreadyMuted, member.name)
			end
		end

		local author = data.member

		if member.highestRole.position >= data.guild.me.highestRole.position
		or member.highestRole.position >= author.highestRole.position then
			canMute = false
			table.insert(notMuted, member.name)
		end

		if canMute then
			local guid = newGuid()
			local guildMute = {
				guid = guid,

				tick = os.time(),
				reason = reason,
				duration = muteTime,

				modId = author.id,
				userId = member.id,
				guildId = data.guild.id,
			}

			tempMutes:set(guid, {
				userId = member.id,
				guildId = data.guild.id,
			})
			guildMutes:set(member.id, guildMute)

			saves.temp:save()
			guildData:save()

			member:addRole(role)
			resumeMute(guid)

			table.insert(muted, member.name)
		end
	end

	local text = ""

	if #muted > 0 then
		text = text ~= "" and string.format("%s\n", text) or text
		text = string.format(
			"%s%s",
			text,
			localize(
				(#muted == 1 and "${followingUserBeenMuted}") or "${followingUsersBeenMuted}",
				guildLang, table.concat(muted, ", "), formalMuteTime
			)
		)
	end

	if #alreadyMuted > 0 then
		text = text ~= "" and string.format("%s\n", text) or text
		text = string.format(
			"%s%s",
			text,
			localize(
				(#alreadyMuted == 1 and "${followingUserAlreadyMuted}") or "${followingUsersAlreadyMuted}",
				guildLang, table.concat(alreadyMuted, ", ")
			)
		)
	end

	if #notMuted > 0 then
		text = text ~= "" and string.format("%s\n", text) or text
		text = string.format(
			"%s%s",
			text,
			localize(
				(#notMuted == 1 and "${followingUserCannotMute}") or "${followingUsersCannotMute}",
				guildLang, table.concat(notMuted, ", ")
			)
		)
	end

	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
