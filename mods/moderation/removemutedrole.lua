local _config = {
	name = "removemutedrole",
	desc = "${removesRoleMuted}",
	usage = "${nameKey}",
	aliases = {"rrmuted", "rrolemuted", "removemuted"},
	cooldown = 0,
	level = 3,
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

	if role then
		local text = parseFormat("${roleRemovedMuted}", langList, roleName)
		local embed = replyEmbed(text, data.message, "ok")

		guildData:get("roles"):set(role.id, nil)
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
