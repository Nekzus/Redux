--[[
{
	"UserId": 110839429,
	"TotalFriends": 5121,
	"CurrentPage": 0,
	"PageSize": 18,
	"TotalPages": 285,
	"FriendsType": "Followers",
	"PreviousPageCursor": null,
	"NextPageCursor": "5436115543_1_9ccb4479a02e188821b2c4ca3002b1cb",
	"Friends": [
		{
		"UserId": 962223187,
		"AbsoluteURL": "https://www.roblox.com/users/962223187/profile/",
		"Username": "yureamavel12",
		"AvatarUri": "https://tr.rbxcdn.com/6138f901c4b20f7397e6ed130a9ba491/30/30/Avatar/Png",
		"AvatarFinal": true,
		"OnlineStatus": {
		"LocationOrLastSeen": "Website",
		"ImageUrl": "~/images/online.png",
		"AlternateText": "yureamavel12 is online."
		},
		"Thumbnail": {
		"Final": true,
		"Url": "https://tr.rbxcdn.com/6138f901c4b20f7397e6ed130a9ba491/30/30/Avatar/Png",
		"RetryUrl": null,
		"UserId": 962223187,
		"EndpointType": "Avatar"
		},
		"InvitationId": 0,
		"LastLocation": "Jailbreak 3-BILLION!",
		"PlaceId": 606849621,
		"AbsolutePlaceURL": "https://www.roblox.com/games/refer?PlaceId=606849621&Position=1&Page=0&PageType=Friends",
		"IsOnline": true,
		"InGame": true,
		"InStudio": false,
		"IsFollowed": true,
		"FriendshipStatus": 0,
		"IsDeleted": false
		},
	]
]]

function apiRobloxGetUserFollowers(id, perPage)
	perPage = perPage or 18

	local data, request = httpGet("robloxGetUserFollowers", {perPage, id})
	local decode = json.decode(request)

	if not decode then
		print("Unable to decode apiRobloxGetUserFollowers()")
		return nil
	end

	return decode
end

return apiRobloxGetUserFollowers
