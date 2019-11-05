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
	local langData = langs[guildLang]
	local args = data.args

	local guild
	local embed = newEmbed()

	if data.user.id == config.main.ownerId and args[2] and type(args[2]) == "string" and #args[2] == 18 and tonumber(args[2]) then
		guild = client:getGuild(args[2])
	else
		guild = data.guild
	end

	embed:thumbnail(data.guild.iconURL)
	embed:field({name = parseFormat("${name}", langData), value = guild.name, inline = true})
	embed:field({name = parseFormat("${id}", langData), value = guild.id, inline = true})
	embed:field({name = parseFormat("${owner}", langData), value = guild.owner.tag, inline = true})
	embed:field({name = parseFormat("${created}", langData), value = discordia.Date.fromSnowflake(guild.id):toISO("T", "Z"), inline = true})
	embed:field({name = parseFormat("${members}", langData), value = format("%s / %s", guild.members:count(isOnline), guild.totalMemberCount), inline = true})
	embed:field({name = parseFormat("${categories}", langData), value = tostring(#guild.categories), inline = true})
	embed:field({name = parseFormat("${textChannels}", langData), value = tostring(#guild.textChannels), inline = true})
	embed:field({name = parseFormat("${voiceChannels}", langData), value = tostring(#guild.voiceChannels), inline = true})
	embed:field({name = parseFormat("${roles}", langData), value = tostring(#guild.roles), inline = true})
	embed:field({name = parseFormat("${emojis}", langData), value = tostring(#guild.emojis), inline = true})

	embed:color(config.colors.blue)
	embed:footerIcon(config.images.info)
	signFooter(embed, data.author, guildLang)

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
