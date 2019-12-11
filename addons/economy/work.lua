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
	local args = data.args

	local memberEconomy, guildEconomy = getMemberEconomy(data.user, data.guild)
	local memberCash = memberEconomy:get("cash", 0)
	local memberBank = memberEconomy:get("bank", 0)
	local symbol = guildEconomy:get("symbol")

	local using = "work"
	local actions = guildEconomy:get("actions")
	local gameData = actions:raw()[using]

	local value = math.random(gameData.income.min, gameData.income.max)

	memberEconomy:set("cash", memberCash + value)

	local responses = {}

	for k, v in next, langs do
		if k:match("workedAs%a+") then
			table.insert(responses, v[guildLang])
		end
	end

	if #responses <= 0 then
		print("Responses not found")
	end

	local text = string.format(responses[math.random(#responses)], string.format("%s %s", symbol, value))
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)
	updateEconomyCommandCooldown(using, data.user, data.guild)

	return true
end

return {config = _config, func = _function}
