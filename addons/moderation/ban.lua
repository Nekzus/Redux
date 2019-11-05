local _config = {
	name = "ban",
	desc = "${bansUser}",
	usage = "${userKey} ${messageKey}",
	aliases = {"banish"},
	cooldown = 0,
	level = 2,
	direct = false,
	perms = {"banMembers"},
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

	local author = data.guild:getMember(data.author)

	if member.highestRole.position >= data.guild.me.highestRole.position
	or member.highestRole.position >= author.highestRole.position then
		local text = parseFormat("${mentionedHigher}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local reason

	if args[3] and #args[3] > 2 then
		reason = data.content:sub(#args[1] + #args[2] + 3)
	end

	if not reason then
		-- member:send(parseFormat("${beenBanned}", langData, data.guild.name, parseFormat("${noReason}", langData)))
		member:ban(parseFormat("[%s]: ${noReason}", langData, author.tag))
	else
		-- member:send(parseFormat("${beenBanned}", langData, data.guild.name, reason))
		member:ban(format("[%s]: %s", author.tag, reason))
	end

	local text = parseFormat("${userBanned}", langData, member.tag)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
