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

	local result, action, code = os.execute(format([[
		git add --all &&
		git commit "Upload automatico da base de dados (%s)" &&
		git fetch origin &&
		git pull
	]], os.date("%m/%d/%Y %I:%M %p")))

	commands:flushList()
	loadBot()

	local text = localize("${botModulesReloaded}", guildLang)
	local embed = replyEmbed(text, data.message, "ok")

	decoy:update(nil, embed:raw())

	return true
end

return {config = _config, func = _function}
