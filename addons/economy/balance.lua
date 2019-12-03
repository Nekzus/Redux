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
		local args = data.args

	if mentionsOtherBot(data.message) then
		local text = localize("${noExecuteOtherBot}", guildLang)
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
	embed:field({name = localize("${cash}", guildLang), value = format("%s %s", symbol, affixNum(memberCash or 0)), inline = true})
	embed:field({name = localize("${bank}", guildLang), value = format("%s %s", symbol, affixNum(memberBank or 0)), inline = true})
	embed:field({name = localize("${networth}", guildLang), value = format("%s %s", symbol, affixNum((memberCash or 0) + (memberBank or 0))), inline = true})

	embed:color(paint.info)
	embed:footerIcon(config.images.info)
	signFooter(embed, data.author, guildLang)

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
