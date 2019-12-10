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
	think:saveAllData()

	client:setGame {
		type = 2,
		name = "Shutting down..."
	}

	dos("git add --all")
	dos(format("git commit -m \"Upload da base de dados (%s)\"", os.date("%m/%d/%Y %I:%M %p")))
	dos("git push")

	local text = localize("${botDataSaved}", guildLang)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)
	client:stop()
	os.exit(0)
end

return {config = _config, func = _function}
