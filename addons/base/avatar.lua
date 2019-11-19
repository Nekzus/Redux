local _config = {
	name = "avatar",
	desc = "${seeUserAvatar}",
	usage = "",
	aliases = {"a"},
	cooldown = 3,
	level = 0,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args
	local authorAvatar = data.guild:getMember(data.author.id):getAvatarURL()
	local mentionedUserTag = data.message.mentionedUsers.first.tag
	local mentionedUserAvatar = data.message.mentionedUsers.first:getAvatar()

	local embed = newEmbed()

	if not specifiesUser(data.message) then
		embed:title(localize("${avatarFor}", guildLang, data.author.tag))
		embed:description(localize("${clickOpenInBrowser}", guildLang, authorAvatar))
		embed:image(authorAvatar)
		embed:color(config.colors.blue)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)
	else
		embed:title(localize("${avatarFor}", guildLang, mentionedUserTag))
		embed:description(localize("${clickOpenInBrowser}", guildLang, mentionedUserAvatar))
		embed:image(mentionedUserAvatar)
		embed:color(config.colors.blue)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

	bird:post(nil, embed:raw(), data.channel)

	return true
  end
end

return {config = _config, func = _function}
