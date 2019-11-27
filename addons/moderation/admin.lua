local _config = {
	name = "admin",
	desc = "${adminsUser}",
	usage = "${userKey}",
	aliases = {"adm", "administrator"},
	cooldown = 0,
	level = 3,
	direct = false,
	perms = {"manageRoles"},
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langData = langs[guildLang]
	local args = data.args

	if not specifiesUser(data.message) then
		local text = parseFormat("${specifyUser}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsOwner(data.message) then
		local text = parseFormat("${noExecuteOwner}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsBot(data.message) then
		local text = parseFormat("${noExecuteBot}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsSelf(data.message) then
		local text = parseFormat("${noExecuteSelf}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local user = data.message.mentionedUsers.first
	local member = user and data.guild:getMember(user)

	if not user or not member then
		local text = parseFormat("${userNotFound}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local guildRoles = guildData:get("roles"):raw()
	local roleId = getPrimaryRoleIndex(2, guildRoles)
	local role = roleId and getRole(roleId, "id", data.guild)

	if not role then
		local text = parseFormat("${adminRoleNotFound}; ${adminRoleTip}", langData, data.prefix)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	if role.position >= data.guild.me.highestRole.position then
		local text = parseFormat("${roleSelectedHigher}", langData, role.name)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local text = parseFormat("${userAdmined}", langData, member.tag)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)
	member:addRole(role)

	return true
end

return {config = _config, func = _function}
