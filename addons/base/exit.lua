local _config = {
	name = "exit",
	desc = "${savesBotDataAndEdit}",
	usage = "",
	aliases = {"shutdown", "stop"},
	cooldown = 0,
	level = 5,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	client:removeAllListeners()
	think:saveAll()

	client:setGame {
		type = 2,
		name = "Shutting down..."
	}

	upload()

	local text = localize("${botDataSaved}", guildLang)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)
	client:stop()
	os.exit(0)
end

return {config = _config, func = _function}
