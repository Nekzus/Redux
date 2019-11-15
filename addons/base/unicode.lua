local _config = {
	name = "unicode",
	desc = "${showsEmote}",
	usage = "${emoteKey}",
	aliases = {"debugemote", "dbemote", "dbe", "uni", "uc"},
	cooldown = 0,
	level = 0,
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

	local value = data.content:sub(#args[1] + 2)
	local text = localize("${unicodeResult}", guildLang, value)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
