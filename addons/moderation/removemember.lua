local _config = {
	name = "removemember",
	desc = "${removesAutoRole}",
	usage = "${nameKey}",
	aliases = {"rmember", "removeauto", "rauto"},
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

	if not (args[2]) then
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	if role then
		local text = localize("${roleRemovedAuto}", guildLang, roleName)
		local embed = replyEmbed(text, data.message, "ok")

		guildData:get("roles"):set(role.id, nil)
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
