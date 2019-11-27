local _config = {
	name = "reseteconomy",
	desc = "${resetsServerEconomy}",
	usage = "",
	aliases = {"reconomy", "reco"},
	cooldown = 0,
	level = 4,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
<<<<<<< Updated upstream
	local langData = langs[guildLang]
	local args = data.args

	local guildEconomy = saves.economy:get(data.guild.id)
	local text = parseFormat("${serverEconomyReset}", langData)
=======
	local args = data.args

	local guildEconomy = getGuildEconomy(data.guild.id)
	local text = localize("${serverEconomyReset}", guildLang)
>>>>>>> Stashed changes
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)
	guildEconomy:set("users", {})

	return false
end

return {config = _config, func = _function}
