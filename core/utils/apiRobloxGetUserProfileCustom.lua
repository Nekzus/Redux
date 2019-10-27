function apiRobloxGetUserProfileCustom(id)
	local data, request = httpGet("robloxGetUserProfile", {id})

	if not request then
		print("Unable to decode apiRobloxGetUserProfileCustom()")
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
		status = status or "-",
		created = created or "-",
		placeVisits = placeVisits and placeVisits:gsub(",", "") or "-",
		friendsCount = friendsCount and realNum(friendsCount) or "-",
		followersCount = followersCount and realNum(followersCount) or "-",
		followingsCount = followingsCount and realNum(followingsCount) or "-",
		userHeadShot = userHeadShot,
	}
end

return apiRobloxGetUserProfileCustom
