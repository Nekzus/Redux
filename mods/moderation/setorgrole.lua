local _config = {
	name = "setorgrole",
	desc = "${addsRoleOrganizer}",
	usage = "${nameKey}",
	aliases = {"srorg", "sroleorg", "addorgrole", "addorg"},
	cooldown = 0,
	level = 4,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local roleName = data.content:sub(#data.args[1] + 2)
	local role = getRole(roleName, "name", data.guild)
	local level = 3

	if role then
		local text = parseFormat("${roleAddedOrganizer}", langList, roleName)
		local embed = replyEmbed(text, data.message, "ok")
		local perms = {level = level, added = os.time()}

		guildData:get("roles"):set(role.id, perms)
		bird:post(nil, embed:raw(), data.channel)

		return true
	else
		local text = parseFormat("${roleNotFound}", langList, roleName)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end
end

return {config = _config, func = _function}