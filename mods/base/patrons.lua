local _config = {
	name = "patrons",
	desc = "${listsPatrons}",
	usage = "${pageKey}",
	aliases = {"pats"},
	cooldown = 10,
	level = 5,
	direct = false,
	perms = {"addReactions", "manageMessages"},
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local listTotal = 0
	local listItems = {}

	for userId, obj in pairs(saves.track:get("patrons"):raw()) do
		insert(listItems, {id = userId, level = obj.level})
		listTotal = listTotal + 1
	end

	sort(listItems, function(a, b)
		return a.level > b.level
	end)

	local perPage = 8
	local page = tonumber(args[2]) or 1

	local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuildId)
	local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuildId)
	local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuildId)

	local decoyBird
	local message

	local function showPage()
		local embed = newEmbed()
		local inPage = 0
		local result = ""

		for _, obj in next, paginate(listItems, perPage, page) do
			inPage = inPage + 1

			if result ~= "" then
				result = format("%s\n", result)
			end

			result = parseFormat("%s%s <@!%s>: `${level} %s`", langList, result, topicEmoji.mentionString, obj.id, obj.level)
		end

		local pages = listTotal / perPage

		if tostring(pages):match("%.%d+") then
			pages = max(1, tonumber(tostring(pages):match("%d+") + 1))
		end

		embed:field({
			name = parseFormat("${patrons} (%s/%s) [${page} %s/%s]", langList, inPage, listTotal, page, pages),
			value = (result ~= "" and result or parseFormat("${noResults}", langList))
		})

		embed:color(config.colors.blue)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		if listTotal <= perPage then
			decoyBird = decoyBird == nil and bird:post(nil, embed:raw(), data.channel)
			or decoyBird:update(nil, embed:raw())

			return true
		end

		if decoyBird == nil then
			decoyBird = bird:post(nil, embed:raw(), data.channel)
			blinker = blink(decoyBird:getMessage(), config.timeouts.reaction, {data.user.id})

			decoyBird:addReaction(arwDown)
			decoyBird:addReaction(arwUp)

			blinker:on(arwDown.id, function()
				page = min(pages, page + 1)

				if not private then
					decoyBird:removeReaction(arwDown, data.user.id)
				end

				showPage()
			end)

			blinker:on(arwUp.id, function()
				page = max(1, page - 1)

				if not private then
					decoyBird:removeReaction(arwUp, data.user.id)
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
