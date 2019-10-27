function apiRobloxGetUserProfileCustom(id)
	local data, request = httpGet("robloxGetUserProfile", {id})

	if not request then
		print("Unable to decode apiRobloxGetUserProfileCustom()")
		return nil
	end

	return {
		status = request:match(config.patterns.rbUserProfileStatus.capture),
		created = request:match(config.patterns.rbUserProfileCreated.capture),
		placeVisits = request:match(config.patterns.rbUserProfilePlaceVisits.capture):gsub(",", ""),
		friendsCount = realNum(request:match(config.patterns.rbUserProfileFriendsCount.capture)),
		followersCount = realNum(request:match(config.patterns.rbUserProfileFollowersCount.capture)),
		followingsCount = realNum(request:match(config.patterns.rbUserProfileFollowingsCount.capture)),
		userHeadShot = request:match(config.patterns.rbUserProfileHeadShot.capture),
	}
end

return apiRobloxGetUserProfileCustom
