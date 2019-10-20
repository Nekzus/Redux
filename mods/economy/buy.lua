local _config = {
	name = "buy",
	desc = "${buysItemFromStore}",
	usage = "${nameKey}",
	aliases = {},
	cooldown = 2,
	level = 5,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	if not (args[2]) then
		local text = parseFormat("${missingArg}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local itemName = data.content:sub(#args[1] + 2)
	local itemData = getStoreItem(itemName)

	if not itemData then
		local text = parseFormat("${itemNotFoundName}", langList)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local memberEconomy, guildEconomy = getMemberEconomy(data.user, data.guild)
	local memberCash = memberEconomy:get("cash", 0)
	local memberBank = memberEconomy:get("bank", 0)
	local member = data.guild:getMember(data.author)

	-- edit below

	if value then
		if value < 1 then
			local text = parseFormat("${invalidAmount}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local liquid = memberCash + memberBank

		if liquid >= value then
			if memberCash < value then
				local diff = value - memberCash

				memberBank = memberEconomy:set("bank", memberBank - diff)
				memberCash = memberEconomy:set("cash", memberCash + diff)
			end

			local targetEconomy = getMemberEconomy(target, data.guild)
			local targetBank = targetEconomy:get("bank", 0)

			memberEconomy:set("cash", memberCash - value)
			targetEconomy:set("bank", targetBank + value)

			local text = parseFormat("${userPaidSuccess}", langList, format("%s %s", guildEconomy:get("symbol"), affixNum(value)), target.tag)
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			local text = parseFormat("${notEnoughCash}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	else
		local text = parseFormat("${missingArg}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end
end

return {config = _config, func = _function}
