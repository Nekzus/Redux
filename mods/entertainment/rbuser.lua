local _config = {
	name = "rbuser",
	desc = "--",
	usage = "${userKey}",
	aliases = {},
	cooldown = 0,
	level = 5,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local decoyBird = bird:post(getLoadingEmoji(), nil, data.channel)
	local embed = newEmbed()

	local userName

	signFooter(embed, data.author, guildLang)
end

return {config = _config, func = _function}
