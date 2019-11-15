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
	embed:field({name = localize("${name}", guildLang), value = (user.nickname and format("%s (%s)", user.username, user.nickname) or user.username), inline = true})
	embed:field({name = localize("${discrim}", guildLang), value = user.discriminator, inline = true})
	embed:field({name = localize("${id}", guildLang), value = user.id, inline = true})
	embed:field({name = localize("${status}", guildLang), value = user.status, inline = true})
	embed:field({name = localize("${joinedDisc}", guildLang), value = discordia.Date.fromSnowflake(user.id):toISO("T", "Z"), inline = true})
	embed:field({name = localize("${joinedServer}", guildLang), value = user.joinedAt, user.joinedAt:gsub("%..*", ""):gsub("T", " ") or "?", inline = true})

	embed:color(config.colors.blue)
	embed:footerIcon(config.images.info)
	signFooter(embed, data.author, guildLang)

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
