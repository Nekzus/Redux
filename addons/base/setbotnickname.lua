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

	local member = data.guild:getMember(client.user.id)

	if not (args[2]) then
		member:setNickname(nil)

		local text = localize("${nilNickname}", guildLang)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local sentence = data.content:sub(#args[1] + 2)

	member:setNickname(sentence)

	local text = localize("${nicknameSet}", guildLang, sentence)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
