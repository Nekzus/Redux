local _config = {
	name = "lua",
	desc = "${allowsLua}",
	usage = "${codeKey}",
	aliases = {"run", "f"},
	cooldown = 0,
	level = 5,
	direct = true,
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

	local decoy = bird:post(getLoadingEmoji(), nil, data.channel)
	local success, response = loadCode(data.content:sub(#args[1] + 2), data.message, {os = os, data = data})

	local embed = replyEmbed(response, data.message, (success and "ok" or "error"))

	decoy:update(nil, embed:raw())

	return true
end

return {config = _config, func = _function}
