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
	local args = data.args

	local result, err = apiCat()
	local embed = enrich()

	signFooter(embed, data.author, guildLang)

	if result then
		embed:image(result)
		embed:color(paint.info)
		embed:footerIcon(config.images.info)

		bird:post(nil, embed:raw(), data.channel)

		return true
	else
		embed:description(localize("${couldNotProcess}", guildLang))
		embed:color(paint.error)
		embed:footerIcon(config.images.error)

		bird:post(nil, embed:raw(), data.channel)

		return false
	end
end

return {config = _config, func = _function}
