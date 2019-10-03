local _config = {
	name = "google",
	desc = "${searchesGoogle}",
	usage = "${messageKey}",
	aliases = {"g", "search"},
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

	local arwLeft = getEmoji(config.emojis.arwLeft, "name", baseGuild)
	local arwRight = getEmoji(config.emojis.arwRight, "name", baseGuild)

	local firstTime = true
	local decoyBird = bird:post(getLoadingEmoji(), nil, data.channel)
	local searchTerms = data.content:sub(#args[1] + 2):gsub(" ", "+")
	local searchResult = googleSearchApi(searchTerms)

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
		local curItem = searchResult.items[page]

		if not curItem then
			local text = parseFormat("${googleNotFoundTerms}", langList, searchTerms)
			local embed = replyEmbed(text, data.message, "error")

			decoyBird:update(nil, embed:raw())

			return false
		end

		decoyBird:update(curItem.link, nil)

		if firstTime == true then
			firstTime = false
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
		end
	end

	showPage()

	return true
end

return {config = _config, func = _function}
