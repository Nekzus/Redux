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
	local searchResult = apiWiki(searchTerms, sub(guildLang, 1, 2))
	local list = searchResult

	local page = 1
	local pages = list and #list or 1

	if not list or list.result == nil then
		local text = parseFormat("${couldNotFindTerms}", langData, searchTerms)
		local embed = replyEmbed(text, data.message, "warn")

		decoyBird:update(nil, embed:raw())

		return false
	end

	local function showPage()
		local item = list--list[page]

		if not item then
			local text = parseFormat("${couldNotFindTerms}", langData, searchTerms)
			local embed = replyEmbed(text, data.message, "error")

			decoyBird:update(nil, embed:raw())

			return false
		end

		local embed = newEmbed()
		embed:author(parseFormat("${wikipedia}", langData))
		embed:authorImage(config.images.wikipediaLogo)
		embed:authorUrl(item.link)

		embed:description(parseFormat(
			":book: **%s**\n%s\n\n",
			langData,
			item.result,
			item.definition
		))

		embed:color(config.colors.blue)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		decoyBird:update(nil, embed:raw())
	end

	showPage()

	return true
end

return {config = _config, func = _function}
