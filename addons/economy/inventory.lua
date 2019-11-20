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

	local decoy
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

			result = localize("%s%s `x%s` - **%s** %s", guildLang, result, topicEmoji.mentionString, obj.amount, obj.name, localize(obj.desc, guildLang))
		end

		local pages = listTotal / perPage

		if tostring(pages):match("%.%d+") then
			pages = max(1, tonumber(tostring(pages):match("%d+") + 1))
		end

		embed:title(localize("${inventory} (%s/%s) [${page} %s/%s]", guildLang, inPage, listTotal, page, pages))
		embed:description(result ~= "" and result or localize("${noResults}", guildLang))

		embed:color(paint("blue"))
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		if listTotal <= perPage then
			if decoy == nil then
				decoy = bird:post(nil, embed:raw(), data.channel)
			else
				decoy:update(nil, embed:raw())
			end

			return true
		end

		if decoy == nil then
			decoy = bird:post(nil, embed:raw(), data.channel)
			blinker = blink(decoy:getMessage(), config.timeouts.reaction, {data.user.id})

			blinker:on(arwDown.id, function()
				page = min(pages, page + 1)

				if not private then
					decoy:removeReaction(arwDown, data.user.id)
				end

				showPage()
			end)

			blinker:on(arwUp.id, function()
				page = max(1, page - 1)

				if not private then
					decoy:removeReaction(arwUp, data.user.id)
				end

				showPage()
			end)

			decoy:addReaction(arwDown)
			decoy:addReaction(arwUp)
		else
			decoy:update(nil, embed:raw())
		end
	end

	showPage()

	return true
end

return {config = _config, func = _function}
