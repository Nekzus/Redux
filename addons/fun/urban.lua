local _config = {
	name = "urban",
	desc = "${getsDefinition}",
	usage = "${messageKey}",
	aliases = {"urb"},
	cooldown = 5,
	level = 0,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langData = langs[guildLang]
	local args = data.args

	if not (args[2]) then
		local text = parseFormat("${missingArg}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuild)
	local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuild)

	local firstTime = true
	local decoyBird = bird:post(getLoadingEmoji(), nil, data.channel)
	local searchTerms = data.content:sub(#args[1] + 2):gsub(" ", "+")
	local searchResult = apiUrban(searchTerms)
	local list = searchResult and searchResult.list

	local page = 1
	local pages = list and #list or 1

	if searchResult == nil or searchResult.list == nil then
		local text = parseFormat("${couldNotFindTerms}", langData, searchTerms)
		local embed = replyEmbed(text, data.message, "warn")

		decoyBird:update(nil, embed:raw())

		return false
	end

	local function showPage()
		local item = list[page]

		if not item then
			local text = parseFormat("${couldNotFindTerms}", langData, searchTerms)
			local embed = replyEmbed(text, data.message, "error")

			decoyBird:update(nil, embed:raw())

			return false
		end

		local embed = newEmbed()
		embed:author(parseFormat("${urbanDictionary}", langData))
		embed:authorImage(config.images.urbanDictionary)
		embed:authorUrl(item.permalink)

		embed:description(parseFormat(
			":book: **%s**\n%s\n\n:pencil: **${example}**\n%s\n\n:star: **${rating}**\n%s %s %s %s",
			langData,
			item.word,
			item.definition,
			item.example,
			":+1:", affixNum(item.thumbs_up),
			":-1:", affixNum(item.thumbs_down)
		))

		embed:color(config.colors.blue)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		decoyBird:update(nil, embed:raw())

		if firstTime == true then
			firstTime = false
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
		end
	end

	showPage()

	return true
end

return {config = _config, func = _function}
