local _config = {
	name = "avatar",
	desc = "${seesUserAvatar}",
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
	local user = data.message.mentionedUsers.first
	local member = user and data.guild:getMember(user)

	local embed = newEmbed()

	if specifiesUser(data.message) then
		embed:title(localize("${avatarFor}", guildLang, member.tag))
		embed:description(localize("${clickOpenInBrowser}", guildLang, member:getAvatarURL()))
		embed:image(string.format("%s?size=1024", member:getAvatarURL()))
		embed:color(paint.info)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		bird:post(nil, embed:raw(), data.channel)

	else
		embed:title(localize("${avatarFor}", guildLang, data.author.tag))
		embed:description(localize("${clickOpenInBrowser}", guildLang, authorAvatar))
		embed:image(string.format("%s?size=1024", authorAvatar))
		embed:color(paint.info)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

	bird:post(nil, embed:raw(), data.channel)

	return true
  end
end

return {config = _config, func = _function}
