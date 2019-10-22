local _config = {
	name = "economy",
	desc = "${listsEconomyTopUsers}",
	usage = "${pageKey}",
	aliases = {"top"},
	cooldown = 0,
	level = 0,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local guildEconomy = saves.economy:get(data.guild.id)

	local listTotal = 0
	local listItems = {}

	for memberId, memberEconomy in pairs(guildEconomy:get("users"):raw()) do
		insert(listItems, {id = memberId, cash = memberEconomy.cash or 0, bank = memberEconomy.bank or 0})
		listTotal = listTotal + 1
	end

	sort(listItems, function(a, b)
		return (a.bank + a.cash) > (b.bank + b.cash)
	end)

	local perPage = 8
	local page = tonumber(args[2]) or 1

	local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuildId)
	local arwLeft = getEmoji(config.emojis.arwLeft, "name", baseGuildId)
	local arwRight = getEmoji(config.emojis.arwRight, "name", baseGuildId)

	local decoyBird
	local message

	local function showPage()
		local embed = newEmbed()
		local inPage = 0
		local result = ""

		for _, itemData in next, paginate(listItems, perPage, page) do
			inPage = inPage + 1

			if result ~= "" then
				result = format("%s\n", result)
			end

			result = parseFormat("%s%s <@!%s>: %s %s", langList, result, topicEmoji.mentionString, itemData.id, guildEconomy:get("symbol"), affixNum(itemData.cash + itemData.bank))
		end

		local pages = listTotal / perPage

		if tostring(pages):match("%.%d+") then
			pages = max(1, tonumber(tostring(pages):match("%d+") + 1))
		end

		embed:field({name = parseFormat("${economy} (%s/%s) [${page} %s/%s]", langList, inPage, listTotal, page, pages), value = (result ~= "" and result or parseFormat("${noResults}", langList))})

		embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		if listTotal <= perPage then
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
