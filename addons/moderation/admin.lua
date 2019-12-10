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
	local args = data.args

	if not specifiesUser(data.message) then
		local text = localize("${specifyUser}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsOwner(data.message) then
		local text = localize("${noExecuteOwner}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsBot(data.message) then
		local text = localize("${noExecuteBot}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsSelf(data.message) then
		local text = localize("${noExecuteSelf}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local user = data.message.mentionedUsers.first
	local member = user and data.guild:getMember(user)

	if not member then
		local text = localize("${userNotFound}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local guildRoles = guildData:get("roles"):raw()
	local roleId = getPrimaryRoleIndex(2, guildRoles)
	local role = roleId and getRole(roleId, "id", data.guild)

	if not role then
		local text = localize("${adminRoleNotFound}; ${adminRoleTip}", guildLang, data.prefix)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	if role.position >= data.guild.me.highestRole.position then
		local text = localize("${roleSelectedHigher}", guildLang, role.name)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local text = localize("${userAdmined}", guildLang, member.tag)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)
	member:addRole(role)

	return true
end

return {config = _config, func = _function}
