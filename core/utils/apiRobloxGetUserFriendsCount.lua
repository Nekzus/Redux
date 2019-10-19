--[[
"data": [
    {
      "isOnline": false,
      "isDeleted": false,
      "id": 123456789,
      "name": "UserName",
      "description": "",
      "created": "2018-10-17T13:15:02.977Z"
    },
]
]]

function apiRobloxGetUserFriendsCount(id)
	local data, request = httpGet("robloxGetUserFriendsCount", id)
	local decode = json.decode(request)

	if not decode then
		print("Unable to decode apiRobloxGetUserFriendsCount()")

		return nil
	end

	return decode.count
end

return apiRobloxGetUserFriendsCount
