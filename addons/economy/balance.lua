local _config = {
	name = "balance",
	desc = "${checksBalance}",
	usage = "",
	aliases = {"bal", "net", "networth"},
	cooldown = 0,
	level = 0,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langData = langs[guildLang]
	local args = data.args

	if mentionsOtherBot(data.message) then
		local text = parseFormat("${noExecuteOtherBot}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local memberEconomy, guildEconomy = getMemberEconomy(data.author, data.guild)
	local memberCash = memberEconomy:get("cash", 0)
	local memberBank = memberEconomy:get("bank", 0)
	local symbol = guildEconomy:get("symbol")

	local embed = newEmbed()

	embed:title(data.author.tag)
	embed:authorImage(data.author:getAvatarURL())
	embed:field({name = parseFormat("${cash}", langData), value = format("%s %s", symbol, affixNum(memberCash or 0)), inline = true})
	embed:field({name = parseFormat("${bank}", langData), value = format("%s %s", symbol, affixNum(memberBank or 0)), inline = true})
	embed:field({name = parseFormat("${networth}", langData), value = format("%s %s", symbol, affixNum((memberCash or 0) + (memberBank or 0))), inline = true})

	embed:color(config.colors.blue)
	embed:footerIcon(config.images.info)
	signFooter(embed, data.author, guildLang)

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
