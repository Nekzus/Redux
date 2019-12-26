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
	local args = data.args

	local guild
	local embed = enrich()

	if inList(data.user.id, config.main.ownerList)
	and args[2]
	and type(args[2]) == "string"
	and #args[2] == 18
	and tonumber(args[2]) then
		guild = client:getGuild(args[2])
	end

	guild = guild or data.guild

	embed:title(guild.name)
	embed:thumbnail(guild.iconURL)
	embed:field({
		name = localize("${id}", guildLang),
		value = guild.id,
		inline = true
	})
	embed:field({
		name = localize("${owner}", guildLang),
		value = guild.owner.tag,
		inline = true
	})
	embed:field({
		name = localize("${created}", guildLang),
		value = discordia.Date.fromSnowflake(guild.id):toString("%m/%d/%Y %I:%M %p"),
		inline = true
	})
	embed:field({
		name = localize("${members}", guildLang),
		value = join(
			guild.members:count(isOnline),
			"/",
			guild.totalMemberCount
		),
		inline = true
	})
	embed:field({
		name = localize("${categories}", guildLang),
		value = tostring(#guild.categories),
		inline = true
	})
	embed:field({
		name = localize("${textChannels}", guildLang),
		value = tostring(#guild.textChannels),
		inline = true
	})
	embed:field({
		name = localize("${voiceChannels}", guildLang),
		value = tostring(#guild.voiceChannels),
		inline = true
	})
	embed:field({
		name = localize("${roles}", guildLang),
		value = tostring(#guild.roles),
		inline = true
	})
	embed:field({
		name = localize("${emojis}", guildLang),
		value = tostring(#guild.emojis),
		inline = true
	})

	embed:color(paint.info)
	embed:footerIcon(config.images.info)
	signFooter(embed, data.author, guildLang)

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
