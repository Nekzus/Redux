local _config = {
	name = "demote",
	desc = "${demotesUser}",
	usage = "${userKey}",
	aliases = {"de", "dem"},
	cooldown = 0,
	level = 2,
	direct = false,
	perms = {"manageRoles"},
}

local _function = function(data)
	local private = data.targetMember == nil
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

	local targetUser = data.message.mentionedUsers.first
	local targetMember = targetUser and data.guild:getMember(targetUser)

	if not targetUser or not targetMember then
		local text = localize("${userNotFound}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false
	end

	local author = data.guild:getMember(data.author)

	if targetMember.highestRole.position == author.highestRole.position then
		local text = localize("${noDemoteEqual}", guildLang)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)
		return false
	end

	if targetMember.highestRole.position >= data.guild.me.highestRole.position
	or targetMember.highestRole.position >= author.highestRole.position then
		local text = localize("${mentionedHigher}", guildLang)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)
		return
	end

	local targetRoles = getUserDefinedRoles(targetMember, data.guild)
	local guildRoles = guildData:get("roles"):raw()

	if #targetRoles > 0 then
		local currentRoleData = targetRoles[1]
		local nextRoleId = getRoleIndexLowerThan(currentRoleData.level, guildRoles, currentRoleData.added)

		if not nextRoleId then
			for i = 1, 5 do
				nextRoleId = getHighestRoleIndex(max(0, currentRoleData.level - i), guildRoles)

				if nextRoleId then
					break
				end
			end
		end

		local currentRole = data.guild:getRole(currentRoleData.id)
		local nextRole = data.guild:getRole(nextRoleId)

		if not currentRole then
			local text = localize("${roleNotFound}", guildLang, "<currentRole>")
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)
			return false
		end

		local text = localize("${userDemoted}", guildLang, targetMember.tag, (nextRole and nextRole.name) or (localize("${targetMember}", guildLang)))
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		if nextRole then
			targetMember:addRole(nextRole.id)
		end

		targetMember:removeRole(currentRole.id)
		return true
	end
end

return {config = _config, func = _function}
