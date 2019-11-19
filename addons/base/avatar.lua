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

	local embed = newEmbed()

	if not specifiesUser(data.message) then
		embed:title(localize("${avatarFor}", guildLang, data.author.tag))
		embed:image(data.guild:getMember(data.author.id):getAvatarURL())
		embed:color(config.colors.blue)
		embed:footerIcon(config.images.info)
		signFooter(embed, message.author, guildLang)

	bird:post(nil, embed:raw(), data.channel)

	return true
  end
end

return {config = _config, func = _function}
