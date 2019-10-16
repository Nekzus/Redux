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
	local langList = langs[guildLang]
	local args = data.args

	local translateLang = data.args[2]
	local translateTerms = data.args[3] and data.content:sub(#args[1] + #args[2] + 3)

	if translateLang == nil or tonumber(translateLang) then
		local nCount = 0
		local rList = {}

		for langName, langCode in pairs(config.langsCodes) do
			insert(rList, {name = langName, code = langCode})
			nCount = nCount + 1
		end

		sort(rList, function(a, b)
			return a.name < b.name
		end)

		local perPage = 8
		local page = tonumber(args[2]) or 1

		local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuild)
		local arwLeft = getEmoji(config.emojis.arwLeft, "name", baseGuild)
		local arwRight = getEmoji(config.emojis.arwRight, "name", baseGuild)
		local decoyBird
		local message

		local function showPage()
			local embed = newEmbed()
			local count = 0
			local result = ""

			for _, obj in next, paginate(rList, perPage, page) do
				count = count + 1

				if result ~= "" then
					result = format("%s\n", result)
				end

				result = parseFormat("%s%s **%s** `%s`", langList, result, topicEmoji.mentionString, obj.name, obj.code)
			end

			local pages = nCount / perPage

			if tostring(pages):match("%.%d+") then
				pages = max(1, tonumber(tostring(pages):match("%d+") + 1))
			end

			embed:field({name = parseFormat("${translationCodes} (%s/%s) [${page} %s/%s]", langList, count, nCount, page, pages), value = (result ~= "" and result or parseFormat("${noResults}", langList))})

			embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
			embed:footerIcon(config.images.info)
			signFooter(embed, data.author, guildLang)

			if nCount <= perPage then
				decoyBird = decoyBird == nil and bird:post(nil, embed:raw(), data.channel)
				or decoyBird:update(nil, embed:raw())

				return true
			end

			if decoyBird == nil then
				decoyBird = bird:post(nil, embed:raw(), data.channel)
				message = decoyBird.message
				blinker = blink(message, config.meta.reactionTimeout, {data.user.id})

				message:addReaction(arwLeft)
				message:addReaction(arwRight)

				blinker:on(arwLeft.id, function()
					page = max(1, page - 1)
					if not private then
						message:removeReaction(arwLeft, data.user.id)
					end
					showPage()
				end)

				blinker:on(arwRight.id, function()
					page = min(pages, page + 1)
					if not private then
						message:removeReaction(arwRight, data.user.id)
					end
					showPage()
				end)
			else
				decoyBird:update(nil, embed:raw())
			end
		end

		showPage()

	elseif translateTerms == nil then
		local nCount = 0
		local rList = {}

		if sub(translateLang, 1, 1) == "\"" or sub(translateLang, 1,1) == "'" then
			translateLang = translateLang:match("%w+")

			for langName, langCode in next, config.langsCodes do
				if langName:lower() == translateLang or langCode:lower() == translateLang then
					insert(rList, {name = langName, code = langCode})
					nCount = nCount + 1
				end
			end
		else
			for langName, langCode in next, config.langsCodes do
				if langName:lower():find(translateLang) or langCode:lower():find(translateLang) then
					insert(rList, {name = langName, code = langCode})
					nCount = nCount + 1
				end
			end
		end

		sort(rList, function(a, b)
			return a.name < b.name
		end)

		local perPage = 8
		local page = tonumber(args[2]) or 1

		local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuild)
		local arwLeft = getEmoji(config.emojis.arwLeft, "name", baseGuild)
		local arwRight = getEmoji(config.emojis.arwRight, "name", baseGuild)
		local decoyBird
		local message

		local function showPage()
			local embed = newEmbed()
			local count = 0
			local result = ""

			for _, obj in next, paginate(rList, perPage, page) do
				count = count + 1

				if result ~= "" then
					result = format("%s\n", result)
				end

				result = parseFormat("%s%s **%s** `%s`", langList, result, topicEmoji.mentionString, obj.name, obj.code)
			end

			local pages = nCount / perPage

			if tostring(pages):match("%.%d+") then
				pages = max(1, tonumber(tostring(pages):match("%d+") + 1))
			end

			embed:field({name = parseFormat("${translationCodes} (%s/%s) [${page} %s/%s]", langList, count, nCount, page, pages), value = (result ~= "" and result or parseFormat("${noResults}", langList))})

			embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
			embed:footerIcon(config.images.info)
			signFooter(embed, data.author, guildLang)

			if nCount <= perPage then
				decoyBird = decoyBird == nil and bird:post(nil, embed:raw(), data.channel)
				or decoyBird:update(nil, embed:raw())

				return true
			end

			if decoyBird == nil then
				decoyBird = bird:post(nil, embed:raw(), data.channel)
				message = decoyBird.message
				blinker = blink(message, config.meta.reactionTimeout, {data.user.id})

				message:addReaction(arwLeft)
				message:addReaction(arwRight)

				blinker:on(arwLeft.id, function()
					page = max(1, page - 1)
					if not private then
						message:removeReaction(arwLeft, data.user.id)
					end
					showPage()
				end)

				blinker:on(arwRight.id, function()
					page = min(pages, page + 1)
					if not private then
						message:removeReaction(arwRight, data.user.id)
					end
					showPage()
				end)
			else
				decoyBird:update(nil, embed:raw())
			end
		end

		showPage()

	else
		local decoyBird = bird:post(getLoadingEmoji(), nil, data.channel)
		local translateResult = apiGoogleTranslate(translateLang, translateTerms:gsub("\n", "%%0A"):gsub(" ", "%%20"))

		if translateResult == nil or translateResult.data == nil then
			local text = parseFormat("${googleNotFoundTerms}", langList, translateLang)
			local embed = replyEmbed(text, data.message, "warn")

			decoyBird:update(nil, embed:raw())

			return false
		end

		local translateData = translateResult.data
		local translation = translateData.translations[1]
		local translatedText = translation.translatedText
		local detectedSourceLanguage = translation.detectedSourceLanguage

		if not translatedText then
			local text = parseFormat("${googleNotFoundTerms}", langList, translateLang)
			local embed = replyEmbed(text, data.message, "error")

			decoyBird:update(nil, embed:raw())

			return false
		end

		local embed = newEmbed()

		signFooter(embed, data.author, guildLang)

		embed:field({
			name = parseFormat("${translation}", langList),
			value = format("```%s```", translatedText),
			inline = true,
		})
		embed:field({
			name = parseFormat("${sourceLanguage}", langList),
			value = format("```%s```", detectedSourceLanguage),
			inline = true,
		})
		embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
		embed:footerIcon(config.images.info)

		decoyBird:update(nil, embed:raw())
	end

	return true
end

return {config = _config, func = _function}
