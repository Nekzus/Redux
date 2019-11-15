local _config = {
	name = "ping",
	desc = "${saysPong}",
	usage = "",
	aliases = {"p"},
	cooldown = 3,
	level = 0,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
		local args = data.args

	local text = localize("${pong}!", guildLang)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
