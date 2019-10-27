local _config = {
	name = "giveitem",
	desc = "${givesItemToSomeone}",
	usage = "${numKey} ${nameKey} ${userKey}, ${userKey} ..",
	aliases = {"give"},
	cooldown = 2,
	level = 5,
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

	elseif mentionsSelf(data.message) then
		local text = parseFormat("${noExecuteSelf}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false

	elseif mentionsOtherBot(data.message) then
		local text = parseFormat("${noExecuteOtherBot}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false
	end
end

return {config = _config, func = _function}
