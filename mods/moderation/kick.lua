local _config = {
	name = "kick",
	desc = "${kicksUser}",
	usage = "${userKey} ${reasonKey}",
	aliases = {},
	cooldown = 0,
	level = 1,
	direct = false,
	perms = {"kickMembers"},
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

	local author = data.guild:getMember(data.author)

	if member.highestRole.position >= data.guild.me.highestRole.position
	or member.highestRole.position >= author.highestRole.position then
		local text = parseFormat("${mentionedHigher}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local reason

	if args[3] and #args[3] > 2 then
		reason = data.content:sub(#args[1] + #args[2] + 3)
	end

	if not reason then
		member:send(parseFormat("${beenKicked}", langList, data.guild.name, parseFormat("${noReason}", langList)))
		member:kick(parseFormat("[%s]: ${noReason}", langList, author.tag))
	else
		member:send(parseFormat("${beenKicked}", langList, data.guild.name, reason))
		member:kick(format("[%s]: %s", author.tag, reason))
	end

	local text = parseFormat("${userKicked}", langList, member.tag)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
