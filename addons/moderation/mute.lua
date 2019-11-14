local _config = {
	name = "mute",
	desc = "${mutesUser}",
	usage = "${userKey} \"${reasonKey}\" ${numKey}",
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

	local muted = {}
	local notMuted = {}
	local alreadyMuted = {}

	local muteTime = data.content:match("%w+$")
	muteTime = muteTime and clamp(interpTime(muteTime), config.time.second * 5, config.time.month)
	or config.time.hour

	local formalMuteTime = parseFormat(timeLong(muteTime), langData)
	local reason = data.content:match(config.patterns.quotes.capture)

	for _, user in next, data.message.mentionedUsers:toArray() do
		local member = user and data.guild:getMember(user.id)
		local canMute = true

		if not user or not member then
			canMute = false
			insert(notMuted, member.name)
		end

		local tempMutes = saves.temp:get("mutes")
		local muteData = guildData:get("mutes"):raw()[member.id]

		if muteData then
			if member:hasRole(role) then
				canMute = false
				insert(alreadyMuted, member.name)
			else
				if tempMutes:raw()[muteData.guid] then
					tempMutes:set(muteData.guid, nil)
				end
			end
		end

		local author = data.guild:getMember(data.author)

		if member.highestRole.position >= data.guild.me.highestRole.position
		or member.highestRole.position >= author.highestRole.position then
			canMute = false
			insert(notMuted, member.name)
		end

		if canMute then
			local guid = newGuid()
			local tempMutes = saves.temp:get("mutes")

			local muteData = {
				added = os.time(),
				duration = muteTime,
				reason = reason,
				moderator = author.id,
				userId = member.id,
				guild = data.guild.id,
				guid = guid,
			}

			tempMutes:set(guid, muteData)
			guildData:get("mutes"):set(member.id, muteData)
			handleMuteData(muteData)
			member:addRole(role)
			insert(muted, member.name)
		end
	end

	local text = ""

	if #muted > 0 then
		text = text ~= "" and format("%s\n", text) or text
		text = format(
			"%s%s",
			text,
			parseFormat(
				(#muted == 1 and "${followingUserBeenMuted}") or "${followingUsersBeenMuted}",
				langData, concat(muted, ", "), formalMuteTime
			)
		)
	end

	if #alreadyMuted > 0 then
		text = text ~= "" and format("%s\n", text) or text
		text = format(
			"%s%s",
			text,
			parseFormat(
				(#alreadyMuted == 1 and "${followingUserAlreadyMuted}") or "${followingUsersAlreadyMuted}",
				langData, concat(alreadyMuted, ", ")
			)
		)
	end

	if #notMuted > 0 then
		text = text ~= "" and format("%s\n", text) or text
		text = format(
			"%s%s",
			text,
			parseFormat(
				(#notMuted == 1 and "${followingUserCannotMute}") or "${followingUsersCannotMute}",
				langData, concat(notMuted, ", ")
			)
		)
	end

	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
