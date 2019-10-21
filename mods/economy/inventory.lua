local _config = {
	name = "inventory",
	desc = "${buysItemFromStore}",
	usage = "${nameKey}",
	aliases = {"inv", "stuff"},
	cooldown = 2,
	level = 5,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local memberEconomy, guildEconomy = getMemberEconomy(data.user, data.guild)
	local memberInventory = memberEconomy:get("inventory")
	local guildInventory = guildEconomy:get("store")

	local listTotal = 0
	local listItems = {}

	for itemGuid, item in pairs(memberInventory:raw()) do
		local itemData = guildInventory:raw()[itemGuid]

		if not itemData then
			memberInventory:set(itemGuid, nil)
		else
			insert(listItems, {
				name = itemData.itemName,
				desc = itemData.itemDesc,
				price = itemData.itemPrice,
				amount = item.itemAmount,
			})
			listTotal = listTotal + 1
		end
	end

	sort(listItems, function(a, b)
		return a.price > b.price
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
		local inPage = 0
		local result = ""

		for _, obj in next, paginate(listItems, perPage, page) do
			inPage = inPage + 1

			if result ~= "" then
				result = result .. "\n"
			end

			result = parseFormat("%s%s `x%s` - **%s** %s", langList, result, topicEmoji.mentionString, obj.amount, obj.name, parseFormat(obj.desc, langList))
		end

		local pages = listTotal / perPage

		if tostring(pages):match("%.%d+") then
			pages = math.max(1, tonumber(tostring(pages):match("%d+") + 1))
		end

		embed:field({
			name = parseFormat("${inventory} (%s/%s) [${page} %s/%s]", langList, inPage, listTotal, page, pages),
			value = (result ~= "" and result or parseFormat("${noResults}", langList))
		})

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
			blinker = blink(message, config.meta.reactionTimeout, {data.user.id})

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
