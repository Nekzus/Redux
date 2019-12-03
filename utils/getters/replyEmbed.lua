function replyEmbed(text, message, method)
	local embed = newEmbed()
	local private = isPrivateChannel(message.channel)
	local guildData = not private and getGuildData(message.guild)
	local guildLang = guildData and guildData:get("lang") or config.defaultGuild.lang
	local color = paint.grey

	if method == "ok" then
		color = paint.ok

	elseif method == "warn" then
		color = paint.warn

	elseif method == "error" then
		color = paint.error

	elseif method == "no" then
		color = paint.no

	elseif method == "info" then
		color = paint.info
	end

	embed:color(unpack(color))
	embed:footerIcon(config.images[method] or message.author.avatarURL)
	signFooter(embed, message.author, guildLang)

	if text then
		embed:description(text)
	end

	return embed
end

return replyEmbed
