local _config = {
	name = "setbotname",
	desc = "${setsUsername}",
	usage = "${messageKey}",
	aliases = {"setuser", "suser", "su"},
	cooldown = 0,
	level = 5,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	if not (args[2]) then
		local text = parseFormat("${missingArg}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local value = data.content:sub(#args[1] + 2)
	client:setUsername(value)

	local text = parseFormat("${usernameSet}", langList, text)
	local embed = replyEmbed(embed, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
