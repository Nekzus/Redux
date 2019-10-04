local _config = {
	name = "emojify",
	desc = "${emojifiesText}",
	usage = "${messageKey}",
	aliases = {"blocks", "t"},
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

	local text = data.content:sub(#args[1] + 2):lower()
	local result = gsub(text, "%a", ":regional_indicator_%1:"):lower():gsub(" ", ":white_large_square:")
	local embed = replyEmbed(result, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
