local _config = {
	name = "rbuser",
	desc = "--",
	usage = "${userKey}",
	aliases = {},
	cooldown = 0,
	level = 5,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	if not (args[2]) then
		local text = parseFormat("${missingArg}: userName", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local decoyBird = bird:post(getLoadingEmoji(), nil, data.channel)

	local user = apiRobloxGetUser(args[2], "name")
	local friends = apiRobloxGetUserFriends(user.Id)
	local followings = apiRobloxGetUserFollowings(user.Id)
	local followers = apiRobloxGetUserFollowers(user.Id)

	local embed = newEmbed()

	signFooter(embed, data.author, guildLang)
end

return {config = _config, func = _function}
