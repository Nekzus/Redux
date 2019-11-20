local _config = {
	name = "rbuser",
	desc = "${showsRobloxProfile}",
	usage = "${userKey}",
	aliases = {"rbprofile"},
	cooldown = 10,
	level = 0,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	if not (args[2]) then
		local text = localize("${missingArg}: userName", guildLang)
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
		local text = localize("${userNotFound}: %s", guildLang, name)
		local embed = replyEmbed(text, data.message, "warn")

		decoyBird:update(nil, embed:raw())

		return false
	end

	local profileCustom = apiRobloxGetUserProfileCustom(user.Id)
	local primaryGroup = apiRobloxGetUserPrimaryGroup(user.Id)

	local headShot = profileCustom.userHeadShot
	local status = profileCustom.status
	local created = profileCustom.created
	local placeVisits = profileCustom.placeVisits
	local friends = profileCustom.friendsCount
	local followings = profileCustom.followingsCount
	local followers = profileCustom.followersCount

	-- Informações de investimento
	local limiteds = apiRobloxGetUserLimiteds(user.Id)
	local limitedsCount = 0
	local limitedsRAP = 0

	for _, item in next, limiteds do
		limitedsCount = limitedsCount + 1

		local rap = item.recentAveragePrice

		if rap then
			limitedsRAP = limitedsRAP + rap
		end
	end

	local embed = newEmbed()
	local robloxLogo = getEmoji(config.emojis.robloxLogo, "name", baseGuild)

	if headShot then
		embed:thumbnail(headShot)
	end

	embed:author(format("%s (%s)", user.Username, user.Id))
	embed:authorImage(config.images.robloxLogo)
	embed:authorUrl(format("https://www.roblox.com/users/%s/profile", user.Id))
	embed:description(status)
	embed:field({
		name = localize("%s ${createdIn}", guildLang, ":date:"),
		value = created,
	})
	embed:field({
		name = localize("%s ${primaryGroup}", guildLang, ":beginner:"),
		value = primaryGroup and primaryGroup.name or localize("${none}", guildLang),
	})
	embed:field({
		name = localize("%s ${social}", guildLang, ":raising_hand:"),
		value = localize("**${friends}:** %s\n**${following}:** %s\n**${followers}:** %s", guildLang, affixNum(friends), affixNum(followings), affixNum(followers)),
		inline = true,
	})
	embed:field({
		name = localize("%s ${investments}", guildLang, ":moneybag:"),
		value = localize("**${recentAveragePriceTag}:** %s\n**${limiteds}:** %s\n**${userVisits}:** %s", guildLang, affixNum(limitedsRAP), affixNum(limitedsCount), affixNum(placeVisits)),
		inline = true,
	})

	embed:color(paint("red3"))
	signFooter(embed, data.author, guildLang)

	decoyBird:update(nil, embed:raw())

	return true
end

return {config = _config, func = _function}
