local _config = {
	name = "truth",
	desc = "${answersYesNoMaybe}",
	usage = "${messageKey}",
	aliases = {"yn", "ynm", "istrue", "itstrue", "8ball"},
	restrict = {"pt-br"},
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

	local phrase = data.content:sub(#args[1] + 2):lower()
	local text = cubi(phrase, #phrase:split(" ") <= 3 and "neutral")

	bird:post(format("%s %s", data.user.mentionString, text), nil, data.channel)

	return true
end

return {config = _config, func = _function}
