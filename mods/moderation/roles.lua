local _config = {
	name = "roles",
	desc = "${listsDefinedRoles}",
	usage = "",
	aliases = {"rls"},
	cooldown = 0,
	level = 5,
	direct = false,
}

local _function = function(data)
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

	local perPage = 8
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

return {config = _config, func = _function}
