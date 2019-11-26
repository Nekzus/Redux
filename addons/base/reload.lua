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

	bot.loaded = false
	client:removeAllListeners()
	saveAllData()

	if not (args[2] and inList(args[2], {"local", "1", "l"})) then
		runDOS("git pull")
	end

	local text = localize("${botModulesReloaded}", guildLang)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)
	commands:flushList()
	loadBot()

	return true
end

return {config = _config, func = _function}
