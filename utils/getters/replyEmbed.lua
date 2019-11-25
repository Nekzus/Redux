function replyEmbed(text, message, method)
	local embed = newEmbed()
	local private = isPrivateChannel(message.channel)
	local guildData = not private and getGuildData(message.guild)
	local guildLang = guildData and guildData:get("lang") or config.defaultGuild.lang

	embed:color(method == "ok" and paint("green")
	or method == "warn" and paint("yellow")
	or method == "error" and paint("red")
	or method == "no" and paint("red2")
	or method == "info" and paint("blue")
	or paint())
	embed:footerIcon(config.images[method] or message.author.avatarURL)
	signFooter(embed, message.author, guildLang)

	if text then
		embed:description(text)
	end

	return embed
end

return replyEmbed
