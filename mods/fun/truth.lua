local _config = {
	name = "truth",
	desc = "${answersYesNoMaybe}",
	usage = "${messageKey}",
	aliases = {"yn", "ynm", "istrue", "itstrue", "8ball"},
	cooldown = 0,
	level = 0,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local decoy = bird:post(getLoadingEmoji(), nil, data.channel)
	local embed = newEmbed()
	local question = data.content:sub(#args[1] + 2) or "-"
	local resultText, resultImage = apiTruth()

	question:gsub("`", "")
	question:gsub("*", "")
	question:gsub("__", "")
	question:gsub("~", "")

	signFooter(embed, data.author, guildLang)

	if resultText then
		if resultText then
			embed:field({
				name = parseFormat("${question}", langList),
				value = format("```%s```", question),
				inline = true,
			})
			embed:field({
				name = parseFormat("${answer}", langList),
				value = format("```%s```", (resultText == "yes" and parseFormat("${yes}", langList)
					or resultText == "no" and parseFormat("${no}", langList)
				or resultText == "maybe" and parseFormat("${maybe}", langList))),
				inline = true,
			})
		end
		embed:image(resultImage)
		embed:color(config.colors.blue)
		embed:footerIcon(config.images.info)

		decoy:update(nil, embed:raw())

		return true
	else
		embed:description(parseFormat("${couldNotProcess}", langList))
		embed:color(config.colors.red)
		embed:footerIcon(config.images.error)

		decoy:update(nil, embed:raw())

		return false
	end
end

return {config = _config, func = _function}
