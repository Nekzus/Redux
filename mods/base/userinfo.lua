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
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local guild = data.guild
	local member = data.message.mentionedUsers.first.user or data.member
	local embed = newEmbed()

	embed:image(member.avatarURL)
	embed:field({name = parseFormat("${name}", langList), value = (member.nickname and format("%s (%s)", member.username, member.nickname) or member.username), inline = true})
	embed:field({name = parseFormat("${discrim}", langList), value = member.discriminator, inline = true})
	embed:field({name = parseFormat("${id}", langList), value = member.id, inline = true})
	embed:field({name = parseFormat("${status}", langList), value = member.status, inline = true})
	embed:field({name = parseFormat("${joinedDisc}", langList), value = discordia.Date.fromSnowflake(member.id):toISO("T", "Z"), inline = true})
	embed:field({name = parseFormat("${joinedServer}", langList), value = member.joinedAt, member.joinedAt:gsub("%..*", ""):gsub("T", " ") or "?", inline = true})

	embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
	embed:footerIcon(config.images.info)
	signFooter(embed, data.author, guildLang)

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
