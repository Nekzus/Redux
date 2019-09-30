local _config = {
	name = "store",
	desc = "${showsServerStore}",
	usage = "${numKey}",
	aliases = {"st", "market", "mk"},
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

	local guildEconomy = getGuildEconomy(data.guild)
	local guildStore = guildEconomy:get("store")
	local symbol = guildEconomy:get("symbol")

	local nCount = 0
	local rList = {}

	for itemGuid, item in pairs(guildStore:raw()) do
		insert(rList, {name = item.name, desc = item.desc, price = item.price, quant = item.quant, roles = item.role})
		nCount = nCount + 1
	end

	sort(rList, function(a, b)
		return a.price > b.price
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
				result = format("%s\n", result)
			end

			result = format("%s%s **%s** - **%s** %s", result, symbol, obj.price, parseFormat(obj.name, langList), parseFormat(obj.desc, langList))
		end

		local pages = nCount / perPage

		if tostring(pages):match("%.%d+") then
			pages = tostring(pages):match("%d+")
			pages = tostring(tonumber(pages) + 1)
		end

		embed:field({name = parseFormat("${store} (%s/%s) [${page} %s/%s]", langList, count, nCount, page, pages), value = (result ~= "" and result or parseFormat("${noResults}", langList))})

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
