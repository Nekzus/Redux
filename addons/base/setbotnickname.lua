local _config = {
	name = "setbotnickname",
	desc = "${setsNickname}",
	usage = "${messageKey}",
	aliases = {"sbnick", "botnick"},
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

		data.guild:getMember(client.user.id):setNickname(nil)

		local text = localize("${nicknameSet}", guildLang, text)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	data.guild:getMember(client.user.id):setNickname(data.content:sub(#args[1] + 2))

	local text = localize("${nicknameSet}", guildLang, text)
	local embed = replyEmbed(embed, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}