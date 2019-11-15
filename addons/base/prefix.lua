local _config = {
	name = "prefix",
	desc = "${setsPrefix}",
	usage = "${valueKey}",
	aliases = {},
	cooldown = 0,
	level = 3,
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

	local guildData = saves.global:get(data.guild.id)
	local valueSet = guildData:set("prefix", args[2])

	if valueSet then
		local text = localize("${beenDefined}", guildLang, "prefix", valueSet)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	else
		local text = localize("${noAllowEdit}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end
end

return {config = _config, func = _function}
