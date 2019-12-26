local _config = {
	name = "wiki",
	desc = "${getsDefinition}",
	usage = "${messageKey}",
	aliases = {"wk", "w"},
	cooldown = 5,
	level = 0,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	if not (args[2]) then
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuild)
	local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuild)

	local decoy
	local firstTime = true
	local searchTerms = data.content:sub(#args[1] + 2):gsub(" ", "+")
	local searchResult = apiWiki(searchTerms, guildLang:sub(1, 2))
	local list = searchResult

	local page = 1
	local pages = list and #list or 1

	if list == nil then
		local text = localize("${couldNotFindTerms}", guildLang, searchTerms)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local function showPage()
		local item = list[page]

		if not item then
			local text = localize("${couldNotFindTerms}", guildLang, searchTerms)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local embed = newEmbed()
		embed:author(localize("${wikipedia}", guildLang))
		embed:authorImage(config.images.wikipediaLogo)
		embed:authorUrl(item.link)

		embed:description(localize(
			":book: **%s**\n%s\n\n",
			guildLang,
			item.result,
			item.definition
		))

		embed:color(paint.info)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		if decoy then
			decoy:update(nil, embed:raw())
		else
			decoy = bird:post(nil, embed:raw(), data.channel)
		end

		if firstTime == true then
			firstTime = false
			blinker = blink(decoy:getMessage(), config.timeouts.reaction.value, {data.user.id})

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
		end
	end

	showPage()

	return true
end

return {config = _config, func = _function}
