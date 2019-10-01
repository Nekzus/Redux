local _config = {
	name = "unban",
	desc = "${unbansUser}",
	usage = "${userKey}",
	aliases = {"unbanish"},
	cooldown = 0,
	level = 3,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	if not args[2] then
		local text = parseFormat("${specifyUser}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local nCount = 0
	local lastTag = nil

	for ban in data.guild:getBans():iter() do
		if ban.user.tag:lower():match(data.args[2]) then
			nCount = nCount + 1
			lastTag = ban.user.tag
			ban:delete()
		end
	end

	if nCount == 0 or lastTag == nil then
		local text = parseFormat("${userNotFound}", langList)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	if nCount == 1 then
		local text = parseFormat("${userUnbanned}", langList, lastTag)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	elseif nCount > 1 then
		local text = parseFormat("${usersUnbanned}", langList, nCount)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	else
		local text = parseFormat("${userNotFound}", langList, nCount)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end
end

return {config = _config, func = _function}
