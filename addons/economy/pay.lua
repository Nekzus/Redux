local _config = {
	name = "pay",
	desc = "${paysSomeone}",
	usage = "${userKey} ${numKey}",
	aliases = {"transfer", "transf", "tr"},
	cooldown = 2,
	level = 0,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langData = langs[guildLang]
	local args = data.args

	if not (args[2] and args[3]) then
		local text = parseFormat("${missingArg}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	if not specifiesUser(data.message) then
		local text = parseFormat("${specifyUser}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsOwner(data.message) then
		local text = parseFormat("${noExecuteOwner}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsBot(data.message) then
		local text = parseFormat("${noExecuteBot}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsSelf(data.message) then
		local text = parseFormat("${noExecuteSelf}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsOtherBot(data.message) then
		local text = parseFormat("${noExecuteOtherBot}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local memberEconomy, guildEconomy = getMemberEconomy(data.user, data.guild)
	local memberCash = memberEconomy:get("cash", 0)
	local memberBank = memberEconomy:get("bank", 0)

	local member = data.guild:getMember(data.author)
	local target = data.guild:getMember(data.message.mentionedUsers.first)
	local value = abbrevNum(args[3], (memberCash + memberBank))

	if value then
		if value < 1 then
			local text = parseFormat("${invalidAmount}", langData)
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

			local text = parseFormat("${userPaidSuccess}", langData, format("%s %s", guildEconomy:get("symbol"), affixNum(value)), target.tag)
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			local text = parseFormat("${notEnoughCash}", langData)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	else
		local text = parseFormat("${missingArg}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end
end

return {config = _config, func = _function}
