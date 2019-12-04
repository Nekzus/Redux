local _config = {
	name = "reload",
	desc = "${reloadsBotModules}",
	usage = "",
	aliases = {"update", "up", "rel", "reboot", "restart", "res"},
	cooldown = 5,
	level = 5,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	local isLocal = (args[2] and inList(args[2], {"local", "nogit", "l"}))

	bot.loaded = false
	client:removeAllListeners()
	db:saveAllData()

	if not isLocal then
		dos("git pull")
	end

	local text = localize("${botModulesReloaded}", guildLang)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	if isLocal then
		commands:flushList()
		loadBot()
	else
		dos("start init.bat")
		client:stop()
		os.exit(0)
	end

	return true
end

return {config = _config, func = _function}
