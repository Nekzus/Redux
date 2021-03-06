local _config = {
	name = "unban",
	desc = "${unbansUser}",
	usage = "${userKey} ${reasonKey}",
	aliases = {"unbanish"},
	cooldown = 0,
	level = 3,
	direct = false,
	perms = {"banMembers"},
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	if not args[2] then
		local text = localize("${specifyUser}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local count = 0
	local lastTag = nil
	local reason

	if args[3] and #args[3] > 2 then
		reason = data.content:sub(#args[1] + #args[2] + 3)
	else
		reason = localize("${noReason}", guildLang)
	end

	for ban in data.guild:getBans():iter() do
		if ban.user.tag:lower():match(args[2]) then
			count = count + 1
			lastTag = ban.user.tag
			ban:delete(string.format("[%s]: %s", data.author.tag, reason))
		end
	end

	if count == 0 or lastTag == nil then
		local text = localize("${userNotFound}", guildLang)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	if count == 1 then
		local text = localize("${userUnbanned}", guildLang, lastTag)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	elseif count > 1 then
		local text = localize("${usersUnbanned}", guildLang, count)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	else
		local text = localize("${userNotFound}", guildLang, count)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end
end

return {config = _config, func = _function}
