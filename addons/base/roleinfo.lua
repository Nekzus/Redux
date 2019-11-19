local _config = {
	name = "roleinfo",
	desc = "${getRoleInfo}",
	usage = "${messageKey}",
	aliases = {"ri"},
	cooldown = 0,
	level = 5,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	if not (args[2]) then
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	if data.guild:getRole(#args[1] + 2) then
		local roleMembers = getMembersFromRole(#args[1] + 2)
		local text = roleMembers
		local embed = replyEmbed(text, data.message, "info")

		bird:post(nil, embed:raw(), data.channel)
	else
		local text = localize("${roleDoesNotExist}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
	end

	return true
end

return {config = _config, func = _function}
