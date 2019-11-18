local _config = {
	name = "screenshare",
	desc = "${createsScreenshare}",
	usage = "",
	aliases = {"ss", "share", "screen"},
	cooldown = 10,
	level = 0,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	local member = data.member
	local voice = member.voiceChannel

	if not voice then
		local text = localize("${mustBeInGuildVoice}", guildLang)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local embed = replyEmbed(text, data.message, "info")
	local screenLink = apiScreenshare(data.guild.id, voice.id)

	local embed = newEmbed()

	embed:title(localize("${shareLinkForVoice}", guildLang, voice.name))
	embed:description(localize("[${clickHereScreenshare}](%s)", guildLang, screenLink))

	embed:color(config.colors.blue)
	embed:footerIcon(config.images.info)
	signFooter(embed, data.author, guildLang)

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
