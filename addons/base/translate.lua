local _config = {
	name = "translate",
	desc = "${translatesYourText}",
	usage = "${languageKey} ${messageKey}",
	aliases = {"to", "t"},
	cooldown = 5,
	level = 0,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	local translateLang = data.args[2]
	local translateTerms = data.args[3] and data.content:sub(#args[1] + #args[2] + 3)
	local decoy

	if translateLang == nil or tonumber(translateLang) then
		local listTotal = 0
		local listItems = {}

		local supportedLangs = apiGoogleTranslateLangs(guildLang)

		if not supportedLangs then
			print("Could not find languages list")

			return false
		end

		for _, item in pairs(supportedLangs) do
			insert(listItems, {name = item.name, code = item.language})
			listTotal = listTotal + 1
		end

		sort(listItems, function(a, b)
			return a.name < b.name
		end)

		local perPage = 10
		local page = tonumber(args[2]) or 1

		local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuild)
		local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuild)
		local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuild)
		local firstTime = true
		local message

		local function showPage()
			local embed = newEmbed()
			local inPage = 0
			local result = ""

			for _, obj in next, paginate(listItems, perPage, page) do
				inPage = inPage + 1

				if result ~= "" then
					result = format("%s\n", result)
				end

				result = localize("%s%s **%s** `%s`", guildLang, result, topicEmoji.mentionString, obj.name, obj.code)
			end

			local pages = listTotal / perPage

			if tostring(pages):match("%.%d+") then
				pages = max(1, tonumber(tostring(pages):match("%d+") + 1))
			end

			embed:title(localize("${translationCodes} (%s/%s) [${page} %s/%s]", guildLang, inPage, listTotal, page, pages))
			embed:description(result ~= "" and result or localize("${noResults}", guildLang))

			embed:color(paint("blue"))
			embed:footerIcon(config.images.info)
			signFooter(embed, data.author, guildLang)

			if decoy == nil then
				decoy = bird:post(nil, embed:raw(), data.channel)
			else
				decoy:update(nil, embed:raw())
			end

			if listTotal <= perPage then
				return true
			end

			if firstTime == true then
				firstTime = false
				decoy:update(nil, embed:raw())
				message = decoy.message
				blinker = blink(message, config.timeouts.reaction, {data.user.id})

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

				decoy:addReaction(arwDown)
				decoy:addReaction(arwUp)
			else
				decoy:update(nil, embed:raw())
			end
		end

		showPage()

	elseif translateTerms == nil then
		local listTotal = 0
		local listItems = {}
		local supportedLangs = apiGoogleTranslateLangs(guildLang)

		if not supportedLangs then
			print("Could not find languages list")
			return false
		end

		if sub(translateLang, 1, 1) == "\"" or sub(translateLang, 1,1) == "'" then
			translateLang = translateLang:match("%w+")

			for _, item in next, supportedLangs do
				if item.name:lower() == translateLang or item.language:lower() == translateLang then
					insert(listItems, {name = item.name, code = item.language})
					listTotal = listTotal + 1
				end
			end
		else
			for _, item in next, supportedLangs do
				if item.name:lower():find(translateLang) or item.language:lower():find(translateLang) then
					insert(listItems, {name = item.name, code = item.language})
					listTotal = listTotal + 1
				end
			end
		end

		sort(listItems, function(a, b)
			return a.name < b.name
		end)

		local perPage = 10
		local page = tonumber(args[2]) or 1

		local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuild)
		local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuild)
		local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuild)
		local firstTime = true
		local message

		local function showPage()
			local embed = newEmbed()
			local inPage = 0
			local result = ""

			for _, obj in next, paginate(listItems, perPage, page) do
				inPage = inPage + 1

				if result ~= "" then
					result = format("%s\n", result)
				end

				result = localize("%s%s **%s** `%s`", guildLang, result, topicEmoji.mentionString, obj.name, obj.code)
			end

			local pages = listTotal / perPage

			if tostring(pages):match("%.%d+") then
				pages = max(1, tonumber(tostring(pages):match("%d+") + 1))
			end

			embed:title(localize("${translationCodes} (%s/%s) [${page} %s/%s]", guildLang, inPage, listTotal, page, pages))
			embed:description(result ~= "" and result or localize("${noResults}", guildLang))
			embed:color(paint("blue"))
			embed:footerIcon(config.images.info)
			signFooter(embed, data.author, guildLang)

			if decoy == nil then
				decoy = bird:post(nil, embed:raw(), data.channel)
			else
				decoy:update(nil, embed:raw())
			end

			if listTotal <= perPage then
				return true
			end

			if firstTime == true then
				firstTime = false
				decoy:update(nil, embed:raw())
				message = decoy.message
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
			else
				decoy:update(nil, embed:raw())
			end
		end

		showPage()

	else
		local translateResult = apiGoogleTranslate(translateLang, urlEncode(translateTerms))

		if translateResult == nil or translateResult.data == nil then
			local text = localize("${couldNotFindTerms}", guildLang, translateLang)
			local embed = replyEmbed(text, data.message, "warn")

			decoy:update(nil, embed:raw())

			return false
		end

		local translateData = translateResult.data
		local translation = translateData.translations[1]
		local translatedText = translation.translatedText
		local detectedSourceLanguage = translation.detectedSourceLanguage

		if not translatedText then
			local text = localize("${couldNotFindTerms}", guildLang, translateLang)
			local embed = replyEmbed(text, data.message, "error")

			decoy:update(nil, embed:raw())

			return false
		end

		local arrow = getEmoji(config.emojis.arrowIcon, "name", baseGuild)
		local reply = format("%s ``%s`` %s ``%s`` %s", data.author.mentionString, detectedSourceLanguage, arrow.mentionString,data.args[2], urlDecode(translatedText))

		bird:post(reply, nil, data.channel)
	end

	return true
end

return {config = _config, func = _function}
