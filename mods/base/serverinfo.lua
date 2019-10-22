local _config = {
	name = "serverinfo",
	desc = "${returnsServerInfo}",
	usage = "",
	aliases = {"svinfo", "sinfo", "ginfo", "guildinfo"},
	cooldown = 10,
	level = 0,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local guild
	local embed = newEmbed()

	if data.user.id == config.meta.ownerId and args[2] and type(args[2]) == "string" and #args[2] == 18 and tonumber(args[2]) then
		guild = client:getGuild(args[2])
	else
		guild = data.guild
	end

	embed:field({name = parseFormat("${name}", langList), value = guild.name, inline = true})
	embed:field({name = parseFormat("${id}", langList), value = guild.id, inline = true})
	embed:field({name = parseFormat("${owner}", langList), value = guild.owner.tag, inline = true})
	embed:field({name = parseFormat("${created}", langList), value = discordia.Date.fromSnowflake(guild.id):toISO("T", "Z"), inline = true})
	embed:field({name = parseFormat("${members}", langList), value = format("%s / %s", guild.members:count(isOnline), guild.totalMemberCount), inline = true})
	embed:field({name = parseFormat("${categories}", langList), value = tostring(#guild.categories), inline = true})
	embed:field({name = parseFormat("${textChannels}", langList), value = tostring(#guild.textChannels), inline = true})
	embed:field({name = parseFormat("${voiceChannels}", langList), value = tostring(#guild.voiceChannels), inline = true})
	embed:field({name = parseFormat("${roles}", langList), value = tostring(#guild.roles), inline = true})
	embed:field({name = parseFormat("${emojis}", langList), value = tostring(#guild.emojis), inline = true})

	embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
	embed:footerIcon(config.images.info)
	signFooter(embed, data.author, guildLang)

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
