local _config = {
	name = "setbotstatus",
	desc = "${setsBotGame}",
	usage = "${messageKey}",
	aliases = {"sbstatus", "bstatus", "setbotgame", "sbgame", "botgame"},
	cooldown = 0,
	level = 5,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	if not (args[2]) then
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local text = data.content:sub(#args[1] + 2)

	client:setGame(text)

	local text = localize("${playingStatusSet}", guildLang, text)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
