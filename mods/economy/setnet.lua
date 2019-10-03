local _config = {
	name = "setnet",
	desc = "${setsNetAmount}",
	usage = "${userKey} ${numKey}",
	aliases = {"snet", "sn"},
	cooldown = 2,
	level = 3,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	if not (args[2] and args[3]) then
		local text = parseFormat("${missingArg}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

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
	elseif mentionsOtherBot(data.message) then
		local text = parseFormat("${noExecuteOtherBot}", langList)
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

	local memberEconomy, guildEconomy = getMemberEconomy(member, data.guild)
	local symbol = guildEconomy:get("symbol")
	local value = realNum(data.args[3])

	if value then
		local text = parseFormat("${netSetSuccessful}", langList, member.tag, format("%s %s", symbol, affixNum(value)))
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)
		memberEconomy:set("cash", 0)
		memberEconomy:set("bank", value)

		return true
	else
		local text = parseFormat("${cashValueInvalid}", langList, member.tag, value)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end
end

return {config = _config, func = _function}