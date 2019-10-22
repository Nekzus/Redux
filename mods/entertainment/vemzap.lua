local _config = {
	name = "vemzap",
	desc = "${zappifiesText}",
	usage = "${messageKey}",
	aliases = {"zap"},
	cooldown = 0,
	level = 0,
	direct = true,
	restrict = {"pt-br"},
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	if not (args[2]) then
		local text = parseFormat("${missingArg}: level", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local text = data.content:sub(#args[1] + 2)
	local zaped = zap(text, random(1, 3))
	-- local embed = replyEmbed(zaped, data.message, "ok")

	bird:post(zaped, nil, data.channel)

	return true
end

return {config = _config, func = _function}
