local _config = {
	name = "deposit",
	desc = "${depositsCash}",
	usage = "${numKey}",
	aliases = {"dep", "depo"},
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
			value = memberCash
		elseif value:lower() == "half" then
			value = memberCash / 2
		elseif value:match("%d+%%") then
			value = value:match("%d+")

			if value then
				value = (value / 100) * memberCash
			end
		else
			value = realNum(value)
		end
	end

	if value and type(value) == "number" then
		value = math.floor(value)

		if value <= memberCash then
			local text = localize("${cashDeposited}", guildLang, string.format("%s %s", symbol, affixNum(value)))
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)
			memberCash = memberEconomy:set("cash", memberCash - value)
			memberBank = memberEconomy:set("bank", memberBank + value)
			return true
		else
			local text = localize("${insufficientFunds}; ${currentCashAmount}", guildLang, string.format("%s %s", symbol, memberBank))
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
