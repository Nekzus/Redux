local _config = {
	name = "lang",
	desc = "${setsLang}",
	usage = "${valueKey}",
	aliases = {},
	cooldown = 5,
	level = 3,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langData = langs[guildLang]
	local args = data.args

	if not (args[2]) then
		local text = parseFormat("${missingArg}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	if not langs[args[2]] then
		local text = parseFormat("${langNotFound}", langData, args[2])
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end
	
	local valueSet = guildData:set("lang", args[2])

	langData = langs[args[2]]

	if valueSet then
		local text = parseFormat("${beenDefined}", langData, "lang", valueSet)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	else
		local text = parseFormat("${noAllowEdit}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end
end

return {config = _config, func = _function}
