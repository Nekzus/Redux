function replyEmbed(text, message, method)
	local embed = newEmbed()
	local private = isPrivateChannel(message.channel)
	local guildData = not private and getGuildData(message.guild)
	local guildLang = guildData and guildData:get("lang") or config.defaultGuild.lang
	local r, g, b = paint()

	if method == "ok" then
		r, g, b = paint("green")
	elseif method == "warn" then
		r, g, b = paint("yellow")
	elseif method == "error" then
		r, g, b = paint("red")
	elseif method == "no" then
		r, g, b = paint("red2")
	elseif method == "info" then
		r, g, b = paint("blue")
	end

	embed:color(r, g, b)
	embed:footerIcon(config.images[method] or message.author.avatarURL)
	signFooter(embed, message.author, guildLang)

	if text then
		embed:description(text)
	end

	return embed
end

return replyEmbed
