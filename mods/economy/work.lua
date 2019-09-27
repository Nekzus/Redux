local _config = {
	name = "work",
	desc = "${worksForMoney}",
	usage = "",
	aliases = {},
	cooldown = 0,
	level = 0,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local memberEconomy, guildEconomy = getMemberEconomy(data.user, data.guild)
	local memberCash = memberEconomy:get("cash", 0)
	local memberBank = memberEconomy:get("bank", 0)
	local symbol = guildEconomy:get("symbol")

	local using = "work"
	local actions = guildEconomy:get("actions")
	local gameData = actions:raw()[using]

	local value = random(gameData.income.min, gameData.income.max)

	memberEconomy:set("cash", memberCash + value)

	local responses = {}

	for k, v in next, langList do
		if k:match("workedAs%a+") then
			insert(responses, v)
		end
	end

	if #responses <= 0 then
		print("Responses not found")
	end

	local text = format(responses[random(#responses)], format("%s %s", symbol, value))
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)
	updateEconomyCommandCooldown(using, data.user, data.guild)

	return true
end

return {config = _config, func = _function}
