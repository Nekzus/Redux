local _config = {
	name = "feedback",
	desc = "${sendsFeedbackCreator}",
	usage = "",
	aliases = {"fb", "suggest"},
	cooldown = 60 * 10,
	level = 0,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	if not args[2] then
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local text = data.content:sub(#args[1] + 2)
	local guild = client:getGuild(config.main.guilds.home.id)
	local channel = guild and client:getChannel(config.main.guilds.home.channels.feedback)

	if not channel then
		print("Could not find feedback channel")
		return false
	end

	local embed = newEmbed()

	embed:author(data.author.tag)
	embed:authorImage(data.author.avatarURL)
	embed:description(text)
	embed:color(config.colors.blue)
	signFooter(embed, data.author, guildLang)
	embed:footer() -- Apaga  a mensagem padrão do signFooter

	local feedback = bird:post(nil, embed:raw(), channel)

	feedback:addReaction("👍")
	feedback:addReaction("👎")

	local text = localize(
		"${feedbackSubmitted}\n\n[${jumpToMessage}](%s)",
		guildLang,
		feedback:getMessage().link
	)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
