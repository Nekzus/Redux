local _config = {
	name = "emojify",
	desc = "${emojifiesText}",
	usage = "${messageKey}",
	aliases = {"em"},
	cooldown = 2,
	level = 0,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local replaces = {
		[" "] = ":white_large_square:",

		["a"] = ":regional_indicator_a:",
		["b"] = ":regional_indicator_b:",
		["c"] = ":regional_indicator_c:",
		["d"] = ":regional_indicator_d:",
		["e"] = ":regional_indicator_e:",
		["f"] = ":regional_indicator_f:",
		["g"] = ":regional_indicator_g:",
		["h"] = ":regional_indicator_h:",
		["i"] = ":regional_indicator_i:",
		["j"] = ":regional_indicator_j:",
		["k"] = ":regional_indicator_k:",
		["l"] = ":regional_indicator_l:",
		["m"] = ":regional_indicator_m:",
		["n"] = ":regional_indicator_n:",
		["o"] = ":regional_indicator_o:",
		["p"] = ":regional_indicator_p:",
		["q"] = ":regional_indicator_q:",
		["r"] = ":regional_indicator_r:",
		["s"] = ":regional_indicator_s:",
		["t"] = ":regional_indicator_t:",
		["u"] = ":regional_indicator_u:",
		["v"] = ":regional_indicator_v:",
		["w"] = ":regional_indicator_w:",
		["x"] = ":regional_indicator_x:",
		["y"] = ":regional_indicator_y:",
		["z"] = ":regional_indicator_z:",

		["1"] = ":one:",
		["2"] = ":two:",
		["3"] = ":three:",
		["4"] = ":four:",
		["5"] = ":five:",
		["6"] = ":six:",
		["7"] = ":seven:",
		["8"] = ":eight:",
		["9"] = ":nine:",
		["0"] = ":zero:",
	}

	local text = data.content:sub(#args[1] + 2):lower()
	local result = ""

	for i = 1, #text do
		local cur = sub(text, i, i)
		local found = replaces[cur]

		if found then
			result = format("%s%s", result, found)
		end
	end

	if not result:find(":") then
		local text = parseFormat("${missingArg}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	if #result > 2047 then
		local text = parseFormat("${messageTooLong}", langList)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	else
		local embed = replyEmbed(result, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	end
end

return {config = _config, func = _function}
