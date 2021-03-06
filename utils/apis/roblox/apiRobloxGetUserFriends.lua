--[[
{
	"UserId": 110839429,
	"TotalFriends": 164,
	"CurrentPage": 0,
	"PageSize": 18,
	"TotalPages": 10,
	"FriendsType": "AllFriends",
	"PreviousPageCursor": null,
	"NextPageCursor": null,
	"Friends": [
		{
		"UserId": 43742709,
		"AbsoluteURL": "https://www.roblox.com/users/43742709/profile/",
		"Username": "4asas",
		"AvatarUri": "https://tr.rbxcdn.com/11233055a2f41018625799e0c34b8ce0/30/30/Avatar/Png",
		"AvatarFinal": true,
		"OnlineStatus": {
		"LocationOrLastSeen": "6/11/2013 12:38:55 PM",
		"ImageUrl": "~/images/offline.png",
		"AlternateText": "4asas is offline (last seen at 6/11/2013 12:38:55 PM."
		},
		"Thumbnail": {
		"Final": true,
		"Url": "https://tr.rbxcdn.com/11233055a2f41018625799e0c34b8ce0/30/30/Avatar/Png",
		"RetryUrl": null,
		"UserId": 43742709,
		"EndpointType": "Avatar"
		},
		"InvitationId": 0,
		"LastLocation": "Website",
		"PlaceId": null,
		"AbsolutePlaceURL": null,
		"IsOnline": false,
		"InGame": false,
		"InStudio": false,
		"IsFollowed": false,
		"FriendshipStatus": 3,
		"IsDeleted": false
		},
	]
]]

function apiRobloxGetUserFriends(id, perPage)
	perPage = perPage or 18

	local data, request = httpGet("robloxGetUserFriends",
		query.urlencode(perPage),
		query.urlencode(id)
	)

	local decoded = json.decode(request)

	return assert(
		decoded,
		"Unable to decode apiRobloxGetUserFriends"
	)
end

return apiRobloxGetUserFriends
