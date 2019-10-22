local _config = {
	name = "cat",
	desc = "${showCat}",
	usage = "",
	aliases = {},
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

	local decoyBird = bird:post(getLoadingEmoji(), nil, data.channel)
	local result, err = apiCat()
	local embed = newEmbed()

	signFooter(embed, data.author, guildLang)

	if result then
		embed:image(result)
		embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
		embed:footerIcon(config.images.info)

		decoyBird:update(nil, embed:raw())

		return true
	else
		embed:description(parseFormat("${couldNotProcess}", langList))
		embed:color(config.colors.red:match(config.patterns.colorRGB.capture))
		embed:footerIcon(config.images.error)

		decoyBird:update(nil, embed:raw())

		return false
	end
end

return {config = _config, func = _function}
