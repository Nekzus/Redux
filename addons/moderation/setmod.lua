local _config = {
	name = "setmod",
	desc = "${addsRoleMod}",
	usage = "${nameKey}",
	aliases = {"smod"},
	cooldown = 0,
	level = 3,
	direct = false,
	perms = {"manageRoles"},
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	local roleName = data.content:sub(#data.args[1] + 2)
	local role = getRole(roleName, "name", data.guild)
	local level = 1

	if role then
		local text = localize("${roleAddedMod}", guildLang, roleName)
		local embed = replyEmbed(text, data.message, "ok")
		local perms = {level = level, added = os.time()}

		guildData:get("roles"):set(role.id, perms)
		bird:post(nil, embed:raw(), data.channel)

		return true
	else
		local text = localize("${roleNotFound}", guildLang, roleName)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end
end

return {config = _config, func = _function}
