local _config = {
	name = "image",
	desc = "${searchesImage}",
	usage = "${messageKey}",
	aliases = {"img", "i"},
	cooldown = 15,
	level = 0,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	if not args[2] then
		local text = parseFormat("${missingArg}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuildId)
	local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuildId)

	local firstTime = true
	local decoyBird = bird:post(getLoadingEmoji(), nil, data.channel)
	local searchTerms = data.content:sub(#args[1] + 2):gsub(" ", "+")
	local searchResult = apiGoogleSearchImage(searchTerms)

	local page = 1
	local pages = 50

	if searchResult == nil or searchResult.items == nil then
		local text = parseFormat("${googleNotFoundTerms}", langList, searchTerms)
		local embed = replyEmbed(text, data.message, "warn")

		decoyBird:update(nil, embed:raw())

		return false
	end

	pages = #searchResult.items

	local function showPage()
		local item = searchResult.items[page]

		if not item then
			local text = parseFormat("${googleNotFoundTerms}", langList, searchTerms)
			local embed = replyEmbed(text, data.message, "error")

			decoyBird:update(nil, embed:raw())

			return false
		end

		local embed = newEmbed()

		embed:image(item.link)

		embed:color(config.colors.blue)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		decoyBird:update(nil, embed:raw())

		if firstTime == true then
			firstTime = false
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
		end
	end

	showPage()

	return true
end

return {config = _config, func = _function}
