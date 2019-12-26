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

	local isGit = args[2]
	and inList(args[2], {"pull", "git", "g", "update", "up", "get"})

	bot.loaded = false
	client:removeAllListeners()
	think:saveAll()

	if isGit then
		upload()
		dos("git pull")
	end

	local text = localize("${botModulesReloaded}", guildLang)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)
	worker:flushList()
	loadBot()

	return true
end

return {config = _config, func = _function}
