local _config = {
	name = "setmember",
	desc = "${addsAutoRole}",
	usage = "${nameKey}",
	aliases = {"smember", "setauto", "sauto"},
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
	local level = 0

	if not (args[2]) then
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	-- Verifica se o cargo existe
	if not role then
		local text = localize("${roleNotFound}", guildLang, roleName)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	-- Verifica se a posição do cargo é superior ou igual ao do autor
	if role.position >= data.member.highestRole.position then
		local text = localize("${higherRole}", guildLang, role.name)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local text = localize("${roleAddedAuto}", guildLang, roleName)
	local embed = replyEmbed(text, data.message, "ok")
	local perms = {level = level, added = os.time()}

	guildData:get("roles"):set(role.id, perms)
	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
