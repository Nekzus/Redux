local category = "${moderation}"

commands:create({name = "setmodrole",
	desc = "${addsRoleMod}",
	usage = "${nameKey}",
	level = 3,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local roleName = data.content:sub(#data.args[1] + 2)
		local role = getRole(roleName, "name", data.guild)
		local level = 1

		if role then
			local text = parseFormat("${roleAddedMod}", langList, roleName)
			local embed = replyEmbed(text, data.message, "ok")
			local perms = {level = level, added = os.time()}

			guildData:get("roles"):set(role.id, perms)
			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			local text = parseFormat("${roleNotFound}", langList, roleName)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end
}):accept("srmod", "srolemod", "addmodrole", "addmod")

commands:create({name = "removemodrole",
	desc = "${removesRoleMod}",
	usage = "${nameKey}",
	level = 3,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local roleName = data.content:sub(#data.args[1] + 2)
		local role = getRole(roleName, "name", data.guild)

		if role then
			local text = parseFormat("${roleRemovedMod}", langList, roleName)
			local embed = replyEmbed(text, data.message, "ok")

			guildData:get("roles"):set(role.id, nil)
			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			local text = parseFormat("${roleNotFound}", langList, roleName)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end
}):accept("rrmod", "rrolemod", "removemod")

commands:create({name = "setadminrole",
	desc = "${addsRoleAdmin}",
	usage = "${nameKey}",
	level = 3,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local roleName = data.content:sub(#data.args[1] + 2)
		local role = getRole(roleName, "name", data.guild)
		local level = 2

		if role then
			local text = parseFormat("${roleAddedAdmin}", langList, roleName)
			local embed = replyEmbed(text, data.message, "ok")
			local perms = {level = level, added = os.time()}

			guildData:get("roles"):set(role.id, perms)
			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			local text = parseFormat("${roleNotFound}", langList, roleName)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end
}):accept("sradmin", "sroleadmin", "addadminrole", "addadmin")

commands:create({name = "removeadminrole",
	desc = "${removesRoleAdmin}",
	usage = "${nameKey}",
	level = 3,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local roleName = data.content:sub(#data.args[1] + 2)
		local role = getRole(roleName, "name", data.guild)

		if role then
			local text = parseFormat("${roleRemovedAdmin}", langList, roleName)
			local embed = replyEmbed(text, data.message, "ok")

			guildData:get("roles"):set(role.id, nil)
			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			local text = parseFormat("${roleNotFound}", langList, roleName)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end
}):accept("rradmin", "rroleadmin", "removeadmin")

commands:create({name = "setorgrole",
	desc = "${addsRoleOrganizer}",
	usage = "${nameKey}",
	level = 4,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local roleName = data.content:sub(#data.args[1] + 2)
		local role = getRole(roleName, "name", data.guild)
		local level = 3

		if role then
			local text = parseFormat("${roleAddedOrganizer}", langList, roleName)
			local embed = replyEmbed(text, data.message, "ok")
			local perms = {level = level, added = os.time()}

			guildData:get("roles"):set(role.id, perms)
			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			local text = parseFormat("${roleNotFound}", langList, roleName)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end
}):accept("srorg", "sroleorg", "addorgrole", "addorg")

commands:create({name = "removeorgrole",
	desc = "${removesRoleOrganizer}",
	usage = "${nameKey}",
	level = 4,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local roleName = data.content:sub(#data.args[1] + 2)
		local role = getRole(roleName, "name", data.guild)

		if role then
			local text = parseFormat("${roleRemovedOrganizer}", langList, roleName)
			local embed = replyEmbed(text, data.message, "ok")

			guildData:get("roles"):set(role.id, nil)
			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			local text = parseFormat("${roleNotFound}", langList, roleName)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end
}):accept("rrorg", "rroleorg", "removeorg")

commands:create({name = "setmutedrole",
	desc = "${addsRoleMuted}",
	usage = "${nameKey}",
	level = 3,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local roleName = data.content:sub(#data.args[1] + 2)
		local role = getRole(roleName, "name", data.guild)
		local level = -1

		if role then
			local text = parseFormat("${roleAddedMuted}", langList, roleName)
			local embed = replyEmbed(text, data.message, "ok")
			local perms = {level = level, added = os.time()}

			guildData:get("roles"):set(role.id, perms)
			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			local text = parseFormat("${roleNotFound}", langList, roleName)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end
}):accept("srmuted", "srolemuted", "addmutedrole", "addmuted", "srmtd", "addmtd")

commands:create({name = "removemutedrole",
	desc = "${removesRoleMuted}",
	usage = "${nameKey}",
	level = 3,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local roleName = data.content:sub(#data.args[1] + 2)
		local role = getRole(roleName, "name", data.guild)

		if role then
			local text = parseFormat("${roleRemovedMuted}", langList, roleName)
			local embed = replyEmbed(text, data.message, "ok")

			guildData:get("roles"):set(role.id, nil)
			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			local text = parseFormat("${roleNotFound}", langList, roleName)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end
}):accept("rrmuted", "rrolemuted", "removemuted", "rrmtd", "removemtd")

commands:create({name = "roles",
	desc = "${listsDefinedRoles}",
	usage = "",

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local guildRoles = guildData:get("roles")

		local rList = {}
		local nCount = 0

		for roleId, obj in pairs(guildRoles:raw()) do
			local roleExists = getRole(roleId, "id", data.guild)

			if roleExists then
				local isPrimary = getPrimaryRoleIndex(obj.level, guildRoles:raw()) == roleId

				insert(rList, {id = roleId, level = obj.level, primary = isPrimary, added = obj.added})
				nCount = nCount + 1
			end
		end

		sort(rList, function(a, b)
			return a.level > b.level or (a.level == b.level and a.added > b.added)
		end)

		local perPage = 10
		local page = tonumber(args[2]) or 1

		local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuild)
		local arwLeft = getEmoji(config.emojis.arwLeft, "name", baseGuild)
		local arwRight = getEmoji(config.emojis.arwRight, "name", baseGuild)

		local decoyBird
		local message

		local function showPage()
			local embed = newEmbed()
			local count = 0
			local result = ""

			for _, obj in next, paginate(rList, perPage, page) do
				count = count + 1

				if result ~= "" then
					result = result .. "\n"
				end

				local roleTitle = getMatchingRoleTitle(obj.level)

				result = format("%s%s %s@%s: `%s`", result, topicEmoji.mentionString, obj.primary and parseFormat("**[${initial}]** ", langList) or "", getRole(obj.id, "id", data.guild).name, (obj.level and roleTitle and parseFormat(roleTitle, langList)))
			end

			local pages = nCount / perPage

			if tostring(pages):match("%.%d+") then
				pages = math.max(1, tonumber(tostring(pages):match("%d+") + 1))
			end

			embed:field({name = parseFormat("${roles} (%s/%s) [${page} %s/%s]", langList, count, nCount, page, pages), value = (result ~= "" and result or parseFormat("${noResults}", langList))})

			embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
			embed:footerIcon(config.images.info)
			signFooter(embed, data.author, guildLang)

			if nCount <= perPage then
				decoyBird = decoyBird == nil and bird:post(nil, embed:raw(), data.channel)
				or decoyBird:update(nil, embed:raw())

				return true
			end

			if decoyBird == nil then
				decoyBird = bird:post(nil, embed:raw(), data.channel)
				message = decoyBird.message
				blinker = blink(message, config.meta.reactionTimeout, {data.user.id})

				message:addReaction(arwLeft)
				message:addReaction(arwRight)

				blinker:on(arwLeft.id, function()
					page = max(1, page - 1)
					message:removeReaction(arwLeft, data.user.id)
					showPage()
				end)

				blinker:on(arwRight.id, function()
					page = min(pages, page + 1)
					message:removeReaction(arwRight, data.user.id)
					showPage()
				end)
			else
				decoyBird:update(nil, embed:raw())
			end
		end

		showPage()

		return true
	end
}):accept("rols", "rls")

commands:create({name = "ban",
	desc = "${bansUser}",
	usage = "${userKey} ${messageKey}",
	level = 2,

	func = function(data)
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
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local reason

		if args[3] and #args[3] > 2 then
			reason = data.content:sub(#args[1] + #args[2] + 3)
		end

		if not reason then
			member:send(parseFormat("${beenBanned}", langList, data.guild.name, parseFormat("${noReason}", langList)))
			member:ban(parseFormat("[%s]: ${noReason}", langList, author.tag))
		else
			member:send(parseFormat("${beenBanned}", langList, data.guild.name, reason))
			member:ban(format("[%s]: %s", author.tag, reason))
		end

		local text = parseFormat("${userBanned}", langList, member.tag)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	end
}):accept("banish")

commands:create({name = "unban",
	desc = "${unbansUser}",
	usage = "${userKey}",
	level = 3,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		if not args[2] then
			local text = parseFormat("${specifyUser}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local nCount = 0
		local lastTag = nil

		for ban in data.guild:getBans():iter() do
			if ban.user.tag:lower():match(data.args[2]) then
				nCount = nCount + 1
				lastTag = ban.user.tag
				ban:delete()
			end
		end

		if nCount == 0 or lastTag == nil then
			local text = parseFormat("${userNotFound}", langList)
			local embed = replyEmbed(text, data.message, "warn")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		if nCount == 1 then
			local text = parseFormat("${userUnbanned}", langList, lastTag)
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)

			return true
		elseif nCount > 1 then
			local text = parseFormat("${usersUnbanned}", langList, nCount)
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			local text = parseFormat("${userNotFound}", langList, nCount)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end
}):accept("unbanish")

commands:create({name = "kick",
	desc = "${kicksUser}",
	usage = "${userKey} ${messageKey}",
	level = 1,

	func = function(data)
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
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local reason

		if args[3] and #args[3] > 2 then
			reason = data.content:sub(#args[1] + #args[2] + 3)
		end

		if not reason then
			member:send(parseFormat("${beenKicked}", langList, data.guild.name, parseFormat("${noReason}", langList)))
			member:kick(parseFormat("[%s]: ${noReason}", langList, author.tag))
		else
			member:send(parseFormat("${beenKicked}", langList, data.guild.name, reason))
			member:kick(format("[%s]: %s", author.tag, reason))
		end

		local text = parseFormat("${userKicked}", langList, member.tag)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	end
})

commands:create({name = "mute",
	desc = "${mutesUser}",
	usage = "${userKey} ${numKey} ${messageKey}",
	level = 1,

	func = function(data)
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
}):accept("mt")

commands:create({name = "unmute",
	desc = "${unmutesUser}",
	usage = "${userKey}",
	level = 1,

	func = function(data)
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

		local muteData = guildData:get("mutes"):raw()[member.id]

		if not muteData then
			local text = parseFormat("${userNotMuted}", langList, member.tag)
			local embed = replyEmbed(text, data.message, "warn")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

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

		local text = parseFormat("${userUnmuted}", langList, member.tag)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	end
}):accept("umt", "unmt")

commands:create({name = "promote",
	desc = "${promotesUser}",
	usage = "${userKey}",
	level = 2,

	func = function(data)
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
	}):accept("pro", "prom")

	commands:create({name = "demote",
		category = category,
		desc = "${demotesUser}",
		usage = "${userKey}",
		level = 2,

		func = function(data)
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
	}):accept("de", "dem")

	commands:create({name = "mod",
		category = category,
		desc = "${modsUser}",
		usage = "${userKey}",
		level = 2,

		func = function(data)
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

			bird:post(nil, embed:raw(), data.channel)
			member:addRole(role)

			return true
		end
	}):accept("md", "moderator")

	commands:create({name = "unmod",
		category = category,
		desc = "${unmodsUser}",
		usage = "${userKey}",
		level = 2,

		func = function(data)
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

			local guildRoles = guildData:get("roles"):raw()
			local roleId = getPrimaryRoleIndex(1, guildRoles)
			local role = roleId and getRole(roleId, "id", data.guild)

			if not role then
				local text = parseFormat("${modRoleNotFound}; ${modRoleTip}", langList, data.prefix)
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

				return false
			end

			local text = parseFormat("${userUnmoded}", langList, member.tag)
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)
			member:removeRole(role)

			return true
		end
	}):accept("umd", "unmoderator")

	commands:create({name = "admin",
		category = category,
		desc = "${adminsUser}",
		usage = "${userKey}",
		level = 3,

		func = function(data)
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

			local guildRoles = guildData:get("roles"):raw()
			local roleId = getPrimaryRoleIndex(2, guildRoles)
			local role = roleId and getRole(roleId, "id", data.guild)

			if not role then
				local text = parseFormat("${adminRoleNotFound}; ${adminRoleTip}", langList, data.prefix)
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

			local text = parseFormat("${userAdmined}", langList, member.tag)
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)
			member:addRole(role)

			return true
		end
	}):accept("adm")

	commands:create({name = "unadmin",
		category = category,
		desc = "${unadminsUser}",
		usage = "${userKey}",
		level = 2,

		func = function(data)
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

			local guildRoles = guildData:get("roles"):raw()
			local roleId = getPrimaryRoleIndex(2, guildRoles)
			local role = roleId and getRole(roleId, "id", data.guild)

			if not role then
				local text = parseFormat("${adminRoleNotFound}; ${adminRoleTip}", langList, data.prefix)
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

				return false
			end

			local text = parseFormat("${userUnadmined}", langList, member.tag)
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)
			member:removeRole(role)

			return true
		end
	}):accept("uadmin", "uadm")

	commands:create({name = "org",
		category = category,
		desc = "${orgsUser}",
		usage = "${userKey}",
		level = 4,

		func = function(data)
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

			local guildRoles = guildData:get("roles"):raw()
			local roleId = getPrimaryRoleIndex(3, guildRoles)
			local role = roleId and getRole(roleId, "id", data.guild)

			if not role then
				local text = parseFormat("${orgRoleNotFound}; ${orgRoleTip}", langList, data.prefix)
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

			local text = parseFormat("${userOrganizered}", langList, member.tag)
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)
			member:addRole(role)

			return true
		end
	}):accept("organizer")

	commands:create({name = "unorg",
		category = category,
		desc = "${unorgsUser}",
		usage = "${userKey}",
		level = 2,

		func = function(data)
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

			local guildRoles = guildData:get("roles"):raw()
			local roleId = getPrimaryRoleIndex(3, guildRoles)
			local role = roleId and getRole(roleId, "id", data.guild)

			if not role then
				local text = parseFormat("${orgRoleNotFound}; ${orgRoleTip}", langList, data.prefix)
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

				return false
			end

			local text = parseFormat("${userUnorged}", langList, member.tag)
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)
			member:removeRole(role)

			return true
		end
	}):accept("uorg", "unorganizer", "uorganizer")

	commands:create({name = "clear",
		category = category,
		desc = "${purgesMessages}",
		usage = "${numKey}",
		level = 2,

		func = function(data)
			local private = data.member == nil
			local guildData = data.guildData
			local guildLang = data.guildLang
			local langList = langs[guildLang]
			local args = data.args

			if args[2] == nil then
				local text = parseFormat("${missingArg}", langList)
				local embed = replyEmbed(text, data.message, "error")

				bird:post(nil, embed:raw(), data.channel)

				return false
			end

			local maxBulk = 5000
			local perBulk = 100

			local toDelete = 0
			local deleted = 0

			local decoy = bird:post(getLoadingEmoji(), nil, data.channel)
			local v1 = tonumber(args[2])

			if type(v1) == "number" then
				toDelete = v1

				if toDelete > maxBulk then
					local text = parseFormat("${cannotDeleteMoreThanXMessages}; ${defaultAmountSetTo}", langList, maxBulk, maxBulk)
					local embed = replyEmbed(text, data.message, "warn")

					toDelete = maxBulk

					for i = 5, 1, - 1 do
						local countdown = parseFormat("${startingIn}", langList, i)
						decoy:update(countdown, embed:raw(), data.channel)
						wait(1)
					end
				end

				while toDelete > 0 do
					local take = min(perBulk, toDelete)

					toDelete = toDelete - take

					local list = data.channel:getMessagesBefore(data.message.id, take):toArray()
					local success, err = data.channel:bulkDelete(list)

					if not success then
						local knownError = getMatchingDiscordError(err:match("%d+"), langList)
						local text

						if knownError then
							err = knownError
						end

						if deleted > 0 then
							text = parseFormat("${failedContinueDetails} ${successDeletedXMessages}", langList, err, deleted)
						else
							text = parseFormat("${failedContinueDetails}", langList, err)
						end

						local embed = replyEmbed(text, data.message, "error")

						decoy:update(nil, embed:raw(), data.channel)

						return false
					end

					deleted = deleted + take

					if v1 > 100 then
						local text = parseFormat("${deletedCurrentXMessages}", langList, deleted)
						local embed = replyEmbed(text, data.message, "info")

						decoy:update(getLoadingEmoji(), embed:raw(), data.channel)
					end
				end

				if v1 > 100 then
					wait(3)
				end

				local text = parseFormat("${successDeletedXMessages}", langList, deleted)
				local embed = replyEmbed(text, data.message, "ok")

				decoy:update(nil, embed:raw(), data.channel)

				return true
			end

			return false
		end
	}):accept("purge", "delete", "del", "bulk", "clean", "clr", "cln", "cl")
