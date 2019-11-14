local _config = {
	name = "inventory",
	desc = "${showsInventory}",
	usage = "${pageKey}",
	aliases = {"inv", "stuff"},
	cooldown = 2,
	level = 0,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langData = langs[guildLang]
	local args = data.args

	local memberEconomy, guildEconomy = getMemberEconomy(data.user, data.guild)
	local memberInventory = memberEconomy:get("inventory")
	local guildInventory = guildEconomy:get("store")

	local listTotal = 0
	local listItems = {}

	for itemGuid, item in pairs(memberInventory:raw()) do
		local itemData = guildInventory:raw()[itemGuid]

		if not itemData or (item and item.itemAmount and item.itemAmount <= 0) then
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
				result = result .. "\n"
			end

			result = parseFormat("%s%s `x%s` - **%s** %s", langData, result, topicEmoji.mentionString, obj.amount, obj.name, parseFormat(obj.desc, langData))
		end

		local pages = listTotal / perPage

		if tostring(pages):match("%.%d+") then
			pages = math.max(1, tonumber(tostring(pages):match("%d+") + 1))
		end

		embed:field({
			name = parseFormat("${inventory} (%s/%s) [${page} %s/%s]", langData, inPage, listTotal, page, pages),
			value = (result ~= "" and result or parseFormat("${noResults}", langData))
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

			decoyBird:addReaction(arwDown)
			decoyBird:addReaction(arwUp)
		else
			decoyBird:update(nil, embed:raw())
		end
	end

	showPage()

	return true
end

return {config = _config, func = _function}
