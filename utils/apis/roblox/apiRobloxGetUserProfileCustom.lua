local function parsed(text)
	local replaces = { -- https://ascii.cl/htmlcodes.htm
		["&#32;"] = " ",
		["&#33;"] = "!",
		["&#34;"] = "\"",
		["&#35;"] = "#",
		["&#36;"] = "$",
		["&#37;"] = "%",
		["&#38;"] = "&",
		["&#39;"] = "'",
		["&#40;"] = "(",
		["&#41;"] = ")",
		["&#42;"] = "*",
		["&#43;"] = "+",
		["&#44;"] = ",",
		["&#45;"] = "-",
		["&#46;"] = ".",
		["&#47;"] = "/",
	}

	for key, value in next, replaces do
		text = text:gsub(key, value)
	end

	return text
end

function apiRobloxGetUserProfileCustom(id)
	local data, request = httpGet(
		"robloxGetUserProfile",
		query.urlencode(id)
	)

	if not request then
		client:error("Unable to decode apiRobloxGetUserProfileCustom")
		return nil
	end

	local status = request:match(config.patterns.rbUserProfileStatus.capture)
	local created = request:match(config.patterns.rbUserProfileCreated.capture)
	local placeVisits = request:match(config.patterns.rbUserProfilePlaceVisits.capture)
	local friendsCount = request:match(config.patterns.rbUserProfileFriendsCount.capture)
	local followersCount = request:match(config.patterns.rbUserProfileFollowersCount.capture)
	local followingsCount = request:match(config.patterns.rbUserProfileFollowingsCount.capture)
	local userHeadShot = request:match(config.patterns.rbUserProfileHeadShot.capture)

	return {
		status = status and parsed(status) or "-",
		created = created or "-",
		placeVisits = placeVisits and placeVisits:gsub(",", "") or "-",
		friendsCount = friendsCount and realNum(friendsCount) or "-",
		followersCount = followersCount and realNum(followersCount) or "-",
		followingsCount = followingsCount and realNum(followingsCount) or "-",
		userHeadShot = userHeadShot,
	}
end

return apiRobloxGetUserProfileCustom
