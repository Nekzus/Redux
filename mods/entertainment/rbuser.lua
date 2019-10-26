local _config = {
	name = "rbuser",
	desc = "--",
	usage = "${userKey}",
	aliases = {},
	cooldown = 5,
	level = 0,
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

	local sentence = data.content:sub(#args[1] + 2)
	local name = trim(sentence:match("%S+"))

	local decoyBird = bird:post(getLoadingEmoji(), nil, data.channel)

	-- Informações base
	local user = apiRobloxGetUser(name, "name")

	if not user.Id then
		local text = parseFormat("${userNotFound}: %s", langList, name)
		local embed = replyEmbed(text, data.message, "warn")

		decoyBird:update(nil, embed:raw())

		return false
	end

	local friends = apiRobloxGetUserFriends(user.Id)
	local followings = apiRobloxGetUserFollowings(user.Id)
	local followers = apiRobloxGetUserFollowers(user.Id)
	local headShot = apiRobloxGetUserHeadShot(user.Id, true)
	local status = apiRobloxGetUserStatus(user.Id)

	-- Informações de investimento

	local embed = newEmbed()
	local robloxLogo = getEmoji(config.emojis.robloxLogo, "name", baseGuildId)

	embed:thumbnail(headShot.PlayerAvatars[1].Thumbnail.Url)
	embed:title(format("%s %s (%s)", robloxLogo.mentionString, user.Username, user.Id))
	embed:description(status)
	embed:field({
		name = parseFormat("%s ${social}", langList, ":raising_hand:"),
		value = parseFormat("**${friends}:** %s\n**${following}:** %s\n**${followers}:** %s", langList, friends.TotalFriends, followings.TotalFriends, followers.TotalFriends),
		inline = true,
	})
	--[[
	embed:field({
		name = parseFormat("%s ${investments}", langList, ":moneybag:"),
		value = parseFormat("**${recentAveragePriceTag}:** %s", langList, )
	})
	]]

	embed:color(config.colors.red3)
	signFooter(embed, data.author, guildLang)

	decoyBird:update(nil, embed:raw())

	return true
end

return {config = _config, func = _function}
