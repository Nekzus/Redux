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

	local decoy = bird:post(getLoadingEmoji(), nil, data.channel)

	saveAllData()
	bot.loaded = false
	client:removeAllListeners()

	if not (args[2] and inList(args[2], {"local", "1", "l"})) then
		runDOS("git add --all")
		runDOS(format("git commit -m \"Upload da base de dados (%s)\"", os.date("%m/%d/%Y %I:%M %p")))
		runDOS("git push")
		runDOS("git pull")
	end

	commands:flushList()

	local text = localize("${botModulesReloaded}", guildLang)
	local embed = replyEmbed(text, data.message, "ok")

	decoy:update(nil, embed:raw())

	loadBot()

	return true
end

return {config = _config, func = _function}
