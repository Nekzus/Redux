local _config = {
	name = "unicode",
	desc = "${showsEmote}",
	usage = "${emoteKey}",
	aliases = {"debugemote", "dbemote", "dbe", "uni", "uc"},
	cooldown = 0,
	level = 0,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	if not (args[2]) then
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local list = {}

	for _, item in next, args do
		table.insert(list, string.format("\\%s ", item))
	end

	table.remove(list, 1)

	local text = data.content:sub(#args[1] + 2)
	local embed = newEmbed()

	embed:title(localize("${unicode}", guildLang))
	-- embed:description(join(unpack(list)))
	embed:description(string.format("```%s```", text))

	embed:color(paint.info)
	embed:footerIcon(config.images.info)
	signFooter(embed, data.author, guildLang)

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
