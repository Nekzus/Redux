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

	local mutedUsers = ""
	local notMutedUsers = ""
	local alreadyMutedUsers = ""
	local mutedAmount = 0
	local notMutedAmount = 0
	local alreadyMutedAmount = 0

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
			notMutedAmount = notMutedAmount + 1
			notMutedUsers = format("%s, %s", notMutedUsers, member.name)
		end

		local temp = getTempData()
		local tempMutes = temp:get("mutes")
		local muteData = guildData:get("mutes"):raw()[member.id]

		if muteData then
			if member:hasRole(role) then
				canMute = false

				if alreadyMutedUsers ~= "" then
					alreadyMutedUsers = format("%s, ", alreadyMutedUsers, member.name)
				end

				alreadyMutedAmount = alreadyMutedAmount + 1
				alreadyMutedUsers = format("%s%s", alreadyMutedUsers, member.name)
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

			if notMutedUsers ~= "" then
				notMutedUsers = format("%s, ")
			end

			notMutedAmount = notMutedAmount + 1
			notMutedUsers = format("%s%s", notMutedUsers, member.name)
		end

		if canMute then
			local guid = newGuid()
			local temp = getTempData()
			local tempMutes = temp:get("mutes")

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

			if mutedUsers ~= "" then
				mutedUsers = format("%s, ", mutedUsers)
			end

			mutedAmount = mutedAmount + 1
			mutedUsers = format("%s%s", mutedUsers, member.name)
		end
	end

	local text = ""

	if mutedAmount > 0 then
		if text ~= "" then
			text = format("%s\n", text)
		end

		if mutedAmount == 1 then
			text = format("%s%s", text, parseFormat("${followingUserBeenMuted}", langData, mutedUsers, formalMuteTime))
		else
			text = format("%s%s", text, parseFormat("${followingUsersBeenMuted}", langData, mutedUsers, formalMuteTime))
		end
	end

	if alreadyMutedAmount > 0 then
		if text ~= "" then
			text = format("%s\n", text)
		end

		if alreadyMutedAmount == 1 then
			text = format("%s%s", text, parseFormat("${followingUserAlreadyMuted}", langData, alreadyMutedUsers))
		else
			text = format("%s%s", text, parseFormat("${followingUsersAlreadyMuted}", langData, alreadyMutedUsers))
		end
	end

	if notMutedAmount > 0 then
		if text ~= "" then
			text = format("%s\n", text)
		end

		if notMutedAmount == 1 then
			text = format("%s%s", text, parseFormat("${followingUserCannotMute}", langData, notMutedUsers))
		else
			text = format("%s%s", text, parseFormat("${followingUsersCannotMute}", langData, notMutedUsers))
		end
	end

	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
