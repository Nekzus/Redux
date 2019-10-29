local _config = {
	name = "store",
	desc = "${showsServerStore}",
	usage = "${numKey}",
	aliases = {"st", "market", "mk"},
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

	local guildEconomy = getGuildEconomy(data.guild)
	local guildStore = guildEconomy:get("store")
	local symbol = guildEconomy:get("symbol")

	local listTotal = 0
	local listItems = {}

	for itemGuid, item in pairs(guildStore:raw()) do
		insert(listItems, {
			name = item.itemName,
			desc = item.itemDesc,
			price = item.itemPrice,
			stock = item.itemStock,
			roles = item.giveRole
		})
		listTotal = listTotal + 1
	end

	sort(listItems, function(a, b)
		return a.price > b.price
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

			result = format("%s%s%s %s - **%s** %s", result, topicEmoji.mentionString, symbol, affixNum(obj.price), parseFormat(obj.name, langList), parseFormat(obj.desc, langList))
		end

		local pages = listTotal / perPage

		if tostring(pages):match("%.%d+") then
			pages = tostring(pages):match("%d+")
			pages = tostring(tonumber(pages) + 1)
		end

		embed:field({
			name = parseFormat("${store} (%s/%s) [${page} %s/%s]", langList, inPage, listTotal, page, pages),
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
			message = decoyBird.message
			blinker = blink(message, config.timeouts.reaction, {data.user.id})

			message:addReaction(arwUp)
			message:addReaction(arwDown)

			blinker:on(arwUp.id, function()
				page = max(1, page - 1)

				if not private then
					message:removeReaction(arwUp, data.user.id)
				end

				showPage()
			end)

			blinker:on(arwDown.id, function()
				page = min(pages, page + 1)

				if not private then
					message:removeReaction(arwDown, data.user.id)
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
