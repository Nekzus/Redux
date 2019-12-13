local _config = {
	name = "topeconomy",
	desc = "${listsEconomyTopUsers}",
	usage = "${pageKey}",
	aliases = {"top", "topmoney"},
	cooldown = 0,
	level = 0,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	local guildEconomy = getGuildEconomy(data.guild.id)

	local listTotal = 0
	local listItems = {}

	for memberId, memberEconomy in pairs(guildEconomy:get("users"):raw()) do
		table.insert(listItems, {id = memberId, cash = memberEconomy.cash or 0, bank = memberEconomy.bank or 0})
		listTotal = listTotal + 1
	end

	table.sort(listItems, function(a, b)
		return (a.bank + a.cash) > (b.bank + b.cash)
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

		for _, itemData in next, paginate(listItems, perPage, page) do
			inPage = inPage + 1

			if result ~= "" then
				result = string.format("%s\n", result)
			end

			result = localize("%s%s <@!%s>: %s %s", guildLang, result, topicEmoji.mentionString, itemData.id, guildEconomy:get("symbol"), affixNum(itemData.cash + itemData.bank))
		end

		local pages = listTotal / perPage

		if tostring(pages):match("%.%d+") then
			pages = math.max(1, tonumber(tostring(pages):match("%d+") + 1))
		end

		embed:title(localize("${economy} (%s/%s) [${page} %s/%s]", guildLang, inPage, listTotal, page, pages))
		embed:description(result ~= "" and result or localize("${noResults}", guildLang))

		embed:color(paint.info)
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
				page = math.min(pages, page + 1)

				if not private then
					decoy:removeReaction(arwDown, data.user.id)
				end

				showPage()
			end)

			blinker:on(arwUp.id, function()
				page = math.max(1, page - 1)

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
