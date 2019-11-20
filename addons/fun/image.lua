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
	local args = data.args

	if not args[2] then
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuild)
	local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuild)

	local firstTime = true
	local decoyBird = bird:post(getLoadingEmoji(), nil, data.channel)
	local searchTerms = data.content:sub(#args[1] + 2):gsub(" ", "+")
	local searchResult = apiGoogleSearchImage(searchTerms)
	local list = searchResult and searchResult.items

	local page = 1
	local pages = list and #list or 1

	if list == nil then
		local text = localize("${couldNotFindTerms}", guildLang, searchTerms)
		local embed = replyEmbed(text, data.message, "warn")

		decoyBird:update(nil, embed:raw())

		return false
	end

	local function showPage()
		local item = list[page]

		if not item then
			local text = localize("${couldNotFindTerms}", guildLang, searchTerms)
			local embed = replyEmbed(text, data.message, "error")

			decoyBird:update(nil, embed:raw())

			return false
		end

		local embed = newEmbed()

		embed:image(item.link)

		embed:color(paint("blue")
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		decoyBird:update(nil, embed:raw())

		if firstTime == true then
			firstTime = false
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
		end
	end

	showPage()

	return true
end

return {config = _config, func = _function}
