local _config = {
	name = "withdraw",
	desc = "${withdrawsCash}",
	usage = "${numKey}",
	aliases = {"with", "wit"},
	cooldown = 0,
	level = 0,
	direct = false,
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

	local memberEconomy, guildEconomy = getMemberEconomy(data.user, data.guild)
	local memberCash = memberEconomy:get("cash", 0)
	local memberBank = memberEconomy:get("bank", 0)
	local symbol = guildEconomy:get("symbol")
	local value = args[2]

	if type(value) == "string" then
		if value:lower() == "all" then
			value = memberBank
		elseif value:lower() == "half" then
			value = memberBank / 2
		elseif value:match("%d+%%") then
			value = value:match("%d+")

			if value then
				value = (value / 100) * memberBank
			end
		else
			value = realNum(value)
		end
	end

	if value and type(value) == "number" then
		if value <= memberBank then
			local text = localize("${cashWithdrawn}", guildLang, string.format("%s %s", symbol, affixNum(value)))
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)
			memberBank = memberEconomy:set("bank", memberBank - value)
			memberCash = memberEconomy:set("cash", memberCash + value)

			return true
		else
			local text = localize("${insufficientFunds}; ${currentBankAmount}", guildLang, string.format("%s %s", symbol, memberBank))
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	else
		local text = localize("${cashValueInvalid}", guildLang, data.author.tag, value)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end
end

return {config = _config, func = _function}
