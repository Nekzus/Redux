function replyEmbed(text, message, method)
	local embed = newEmbed()
	local private = isPrivateChannel(message.channel)
	local guildData = not private and getGuildData(message.guild)
	local guildLang = guildData and guildData:get("lang") or config.default.lang
	local color

	if method == "ok" then
		color = config.colors.green
	elseif method == "warn" then
		color = config.colors.yellow
	elseif method == "error" then
		color = config.colors.red
	elseif method == "no" then
		color = config.colors.red2
	elseif method == "info" then
		color = config.colors.blue
	end

	embed:color(color:match(config.patterns.colorRGB.capture))
	embed:footerIcon(config.images[method] or message.author.avatarURL)
	if text then
		embed:description(text)
	end
	signFooter(embed, message.author, guildLang)

	return embed
end

return replyEmbed
