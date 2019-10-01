local _config = {
	name = "mute",
	desc = "${mutesUser}",
	usage = "${userKey} ${numKey} ${messageKey}",
	aliases = {"mt"},
	cooldown = 0,
	level = 1,
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

	local user = data.message.mentionedUsers.first
	local member = user and data.guild:getMember(user)

	if not user or not member then
		local text = parseFormat("${userNotFound}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local tempMutes = saves.temp:get("mutes")
	local muteData = guildData:get("mutes"):raw()[member.id]

	if muteData then
		if member:hasRole(role) then
			local text = parseFormat("${alreadyMuted}", langList, member.tag)
			local embed = replyEmbed(text, data.message, "warn")

			bird:post(nil, embed:raw(), data.channel)

			return false
		else
			if tempMutes:raw()[muteData.guid] then
				tempMutes:set(muteData.guid, nil)
			end
		end
	end

	local author = data.guild:getMember(data.author)

	if member.highestRole.position >= data.guild.me.highestRole.position
	or member.highestRole.position >= author.highestRole.position then
		local text = parseFormat("${mentionedHigher}", langList)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local fullText = data.message.cleanContent --getCleanText(data.content:sub(#data.args[1] + 2))
	local muteTime = math.min(interpTime(fullText:gsub('(%b"")', "")), timeInterps.week) or 60 * 60
	local formalMuteTime = timeLong(muteTime)

	local reason

	if args[4] and #args[4] > 2 then
		reason = data.content:sub(#args[1] + #args[2] + #args[3] + 4)
	end

	local guid = newGuid()
	local tempMutes = saves.temp:get("mutes")

	local muteData = {
		added = os.time(),
		duration = muteTime,
		-- reason = reason,
		moderator = author.id,
		user = member.id,
		guild = data.guild.id,
		guid = guid,
	}

	tempMutes:set(guid, muteData)
	guildData:get("mutes"):set(member.id, muteData)
	handleMuteData(muteData)

	if not reason then
		member:send(parseFormat("${beenMuted}", langList, data.guild.name, parseFormat("${noReason}", langList)))
	else
		member:send(parseFormat("${beenMuted}", langList, data.guild.name, reason))
	end

	member:addRole(role)

	local text = parseFormat("${userMuted}", langList, member.tag, parseFormat(formalMuteTime, langList))
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
