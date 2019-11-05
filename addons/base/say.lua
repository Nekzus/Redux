local _config = {
	name = "say",
	desc = "${botSays}",
	usage = "${messageKey}",
	aliases = {"s", "repeat", "rep", "speak"},
	cooldown = 0,
	level = 0,
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

	local canDelete = data.member and saves.global:get(data.guild.id):raw().deleteCommand
	canDelete = canDelete == true

	local value = data.content:sub(#args[1] + 2)
	local embed = replyEmbed(value, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	if not private and canDelete then
		data.message:delete()
	end

	return true
end

return {config = _config, func = _function}
