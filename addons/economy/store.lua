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

	local perPage = 10
	local page = tonumber(args[2]) or 1

	local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuild)
	local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuild)
	local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuild)

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

			result = format("%s%s%s %s - **%s** %s", result, topicEmoji.mentionString, symbol, affixNum(obj.price), localize(obj.name, guildLang), localize(obj.desc, guildLang))
		end

		local pages = listTotal / perPage

		if tostring(pages):match("%.%d+") then
			pages = tostring(pages):match("%d+")
			pages = tostring(tonumber(pages) + 1)
		end

		embed:title(localize("${store} (%s/%s) [${page} %s/%s]", guildLang, inPage, listTotal, page, pages))
		embed:description(result ~= "" and result or localize("${noResults}", guildLang))

		embed:color(config.colors.blue)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		if listTotal <= perPage then
			if decoyBird == nil then
				decoyBird = bird:post(nil, embed:raw(), data.channel)
			else
				decoyBird:update(nil, embed:raw())
			end

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
