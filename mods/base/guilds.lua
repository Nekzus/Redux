local _config = {
	name = "guilds",
	desc = "${showsGlobalGuildsList}",
	usage = "${pageKey}",
	aliases = {"glist", "gs"},
	cooldown = 0,
	level = 5,
	direct = true,
	perms = {"addReactions", "manageMessages"},
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local perPage = 8
	local page = tonumber(args[2]) or 1

	local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuildId)
	local arwLeft = getEmoji(config.emojis.arwLeft, "name", baseGuildId)
	local arwRight = getEmoji(config.emojis.arwRight, "name", baseGuildId)

	local decoyBird
	local message

	local function showPage()
		local embed = newEmbed()
		local count = 0
		local result = ""

		local rList = client.guilds:toArray()
		local nCount = #rList

		sort(rList, function(a, b)
			return a.name < b.name
		end)

		for _, obj in next, paginate(rList, perPage, page) do
			count = count + 1

			if result ~= "" then
				result = format("%s\n", result)
			end

			local guildName = obj.name

			if #guildName > 15 then
				guildName = format("%s...", sub(guildName, 1, 15))
			end

			result = parseFormat("%s%s **%s**: `%s`", langList, result, topicEmoji.mentionString, guildName, obj.id)
		end

		local pages = nCount / perPage

		if tostring(pages):match("%.%d+") then
			pages = max(1, tonumber(tostring(pages):match("%d+") + 1))
		end

		embed:field({name = parseFormat("${guilds} (%s/%s) [${page} %s/%s]", langList, count, nCount, page, pages), value = (result ~= "" and result or parseFormat("${noResults}", langList))})

		embed:color(config.colors.blue)
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
			blinker = blink(message, config.timeouts.reaction, {data.user.id})

			message:addReaction(arwLeft)
			message:addReaction(arwRight)

			blinker:on(arwLeft.id, function()
				page = max(1, page - 1)
				if not private then
					message:removeReaction(arwLeft, data.user.id)
				end
				showPage()
			end)

			blinker:on(arwRight.id, function()
				page = min(pages, page + 1)
				if not private then
					message:removeReaction(arwRight, data.user.id)
				end
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
