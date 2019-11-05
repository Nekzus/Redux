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
	local success, output = pcall(eval, tostring(input))
	local embed = replyEmbed(nil, data.message, "ok")

	embed:field({name = parseFormat("${inputResult}", langData), value = "```" .. input .."```", inline = true})
	embed:field({name = parseFormat("${outputResult}", langData), value = "```" .. output .."```", inline = true})

	if output and type(output) == "string" then
		if output:lower():find("inv")
		or output:lower():find("not")
		or output:lower():find("err") then
			embed:color(config.colors.red)
			embed:footerIcon(config.images.error)
		end
	end

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
