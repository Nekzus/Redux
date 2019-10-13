local _config = {
	name = "translate",
	desc = "${translatesYourText}",
	usage = "${messageKey}",
	aliases = {"to"},
	cooldown = 10,
	level = 0,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	if not (args[2] and args[3]) then
		local text = parseFormat("${missingArg}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local decoyBird = bird:post(getLoadingEmoji(), nil, data.channel)
	local translateLang = data.args[2]
	local translateTerms = data.content:sub(#args[1] + #args[2] + 3):gsub(" ", "+")
	local translateResult = apiGoogleTranslate(translateLang, translateTerms)

	if translateResult == nil or translateResult.data == nil then
		local text = parseFormat("${googleNotFoundTerms}", langList, searchTerms)
		local embed = replyEmbed(text, data.message, "warn")

		decoyBird:update(nil, embed:raw())

		return false
	end

	local translateData = translateResult.data
	local translation = translateData.translations[1]
	local translatedText = translation.translatedText
	local detectedSourceLanguage = translation.detectedSourceLanguage

	if not translatedText then
		local text = parseFormat("${googleNotFoundTerms}", langList, searchTerms)
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

	return true
end

return {config = _config, func = _function}
