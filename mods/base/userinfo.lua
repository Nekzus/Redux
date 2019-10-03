local _config = {
	name = "userinfo",
	desc = "${returnsUserInfo}",
	usage = "${userKey}",
	aliases = {"whois", "wis", "info"},
	cooldown = 5,
	level = 0,
	direct = false,
}

local _function = function(data)
	local private = data.user == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local guild = data.guild
	local user = data.member --data.message.mentionedUsers.first
	local embed = newEmbed()

	embed:image(user.avatarURL)
	embed:field({name = parseFormat("${name}", langList), value = (user.nickname and format("%s (%s)", user.username, user.nickname) or user.username), inline = true})
	embed:field({name = parseFormat("${discrim}", langList), value = user.discriminator, inline = true})
	embed:field({name = parseFormat("${id}", langList), value = user.id, inline = true})
	embed:field({name = parseFormat("${status}", langList), value = user.status, inline = true})
	embed:field({name = parseFormat("${joinedDisc}", langList), value = discordia.Date.fromSnowflake(user.id):toISO("T", "Z"), inline = true})
	embed:field({name = parseFormat("${joinedServer}", langList), value = user.joinedAt, user.joinedAt:gsub("%..*", ""):gsub("T", " ") or "?", inline = true})

	embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
	embed:footerIcon(config.images.info)
	signFooter(embed, data.author, guildLang)

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
