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
		local args = data.args

	if not (args[2] and args[3]) then
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	if not specifiesUser(data.message) then
		local text = localize("${specifyUser}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsOwner(data.message) then
		local text = localize("${noExecuteOwner}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsBot(data.message) then
		local text = localize("${noExecuteBot}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsSelf(data.message) then
		local text = localize("${noExecuteSelf}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsOtherBot(data.message) then
		local text = localize("${noExecuteOtherBot}", guildLang)
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
			local text = localize("${invalidAmount}", guildLang)
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

			local text = localize("${userPaidSuccess}", guildLang, string.format("%s %s", guildEconomy:get("symbol"), affixNum(value)), target.tag)
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			local text = localize("${notEnoughCash}", guildLang)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	else
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end
end

return {config = _config, func = _function}
