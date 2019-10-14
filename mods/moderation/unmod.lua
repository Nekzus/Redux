local _config = {
	name = "unmod",
	desc = "${unmodsUser}",
	usage = "${userKey}",
	aliases = {"umd", "unmoderator"},
	cooldown = 0,
	level = 2,
	direct = false,
	perms = {"manageRoles"},
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	if not specifiesUser(data.message) then
		local text = parseFormat("${specifyUser}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsOwner(data.message) then
		local text = parseFormat("${noExecuteOwner}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsBot(data.message) then
		local text = parseFormat("${noExecuteBot}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsSelf(data.message) then
		local text = parseFormat("${noExecuteSelf}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local user = data.message.mentionedUsers.first
	local member = user and data.guild:getMember(user)

	if not user or not member then
		local text = parseFormat("${userNotFound}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local guildRoles = guildData:get("roles"):raw()
	local roleId = getPrimaryRoleIndex(1, guildRoles)
	local role = roleId and getRole(roleId, "id", data.guild)

	if not role then
		local text = parseFormat("${modRoleNotFound}; ${modRoleTip}", langList, data.prefix)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local author = data.guild:getMember(data.author)

	if member.highestRole.position >= data.guild.me.highestRole.position
	or member.highestRole.position >= author.highestRole.position then
		local text = parseFormat("${mentionedHigher}", langList)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local text = parseFormat("${userUnmoded}", langList, member.tag)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)
	member:removeRole(role)

	return true
end

return {config = _config, func = _function}
