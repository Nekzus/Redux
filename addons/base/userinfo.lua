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
	local langData = langs[guildLang]
	local args = data.args

	local guild = data.guild
	local embed = newEmbed()
	local mentioned = data.message.mentionedUsers.first
	local user

	if mentioned then
		user = data.guild:getMember(mentioned.id)
	else
		user = data.member
	end

	embed:thumbnail(user.avatarURL)
	embed:field({name = parseFormat("${name}", langData), value = (user.nickname and format("%s (%s)", user.username, user.nickname) or user.username), inline = true})
	embed:field({name = parseFormat("${discrim}", langData), value = user.discriminator, inline = true})
	embed:field({name = parseFormat("${id}", langData), value = user.id, inline = true})
	embed:field({name = parseFormat("${status}", langData), value = user.status, inline = true})
	embed:field({name = parseFormat("${joinedDisc}", langData), value = discordia.Date.fromSnowflake(user.id):toISO("T", "Z"), inline = true})
	embed:field({name = parseFormat("${joinedServer}", langData), value = user.joinedAt, user.joinedAt:gsub("%..*", ""):gsub("T", " ") or "?", inline = true})

	embed:color(config.colors.blue)
	embed:footerIcon(config.images.info)
	signFooter(embed, data.author, guildLang)

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
