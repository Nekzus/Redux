local _config = {
	name = "reload",
	desc = "${reloadsBotModules}",
	usage = "",
	aliases = {"rel", "reboot", "restart", "res"},
	cooldown = 3,
	level = 5,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local decoy = bird:post(getLoadingEmoji(), nil, data.channel)

	saveAllData()

	coroutine.wrap(function()
		commands:flushList()
		loadBot()
	end)()

	local text = parseFormat("${botModulesReloaded}", langList)
	local embed = replyEmbed(text, data.message, "ok")

	decoy:update(nil, embed:raw())

	return true
end

return {config = _config, func = _function}
