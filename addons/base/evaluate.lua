local _config = {
	name = "evaluate",
	desc = "${evalsMath}",
	usage = "${pageKey}",
	aliases = {"eval", "ev", "math", "calc", "cal"},
	cooldown = 0,
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

	local input = data.content:sub(#args[1] + 2)
	local result, err = pcall(luaxp.evaluate, tostring(input))
	local embed = replyEmbed(nil, data.message, "ok")

	embed:field({
		name = parseFormat("${inputResult}", langData),
		value = format("```%s```", input),
		inline = true
	})
	embed:field({
		name = parseFormat("${outputResult}", langData),
		value = format("```%s```", result or err and err.message),
		inline = true
	})

	if result then
		embed:color(config.colors.blue)
		embed:footerIcon(config.images.info)
	elseif err then
		embed:color(config.colors.red)
		embed:footerIcon(config.images.error)
	end

	signFooter(embed, data.author, guildLang)

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
