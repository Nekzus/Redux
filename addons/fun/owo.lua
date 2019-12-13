local _config = {
	name = "owo",
	desc = "${owoifiesText}",
	usage = "${messageKey}",
	aliases = {},
	cooldown = 0,
	level = 0,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	local text = data.content:sub(#args[1] + 2):lower()
	local increment = {"owo", "OWO", "OwO", "UwU", ">w<", "^w^", "uwu"}
	local replaces = {
		["r"] = "w",
		["l"] = "w",
		["r"] = "r",
		["ove"] = "uve",
		["n"] = "ny",
		["u"] = "wu",
		["e"] = "we",
		["ae"] = "wae",
		["ai"] = "wai",
		["ay"] = "yay",
		["o"] = "w",
		["uta"] = "wuta",
		["!"] = " " .. increment[math.random(#increment)]
	}

	if isFiltered(text, {"http://", "https://"}) then
		local text = localize("${linksNotSupported}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	for word, replace in pairs(replaces) do
		text = text:gsub(word, replace)
		replaces["!"] = " " .. increment[math.random(#increment)]
	end

	--local embed = replyEmbed(text, data.message, "ok")

	bird:post(text, nil, data.channel)

	return true
end

return {config = _config, func = _function}
