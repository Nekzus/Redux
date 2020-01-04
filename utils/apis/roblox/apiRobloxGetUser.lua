--[[
	{
		"Id": 110839429,
		"Username": "Nekzus",
		"AvatarUri": null,
		"AvatarFinal": false,
		"IsOnline": false
	}
]]

function apiRobloxGetUser(value, method)
	local data, request

	if method == "name" then
		data, request = httpGet(
			"robloxGetUserFromName",
			query.urlencode(value)
		)
	elseif method == "id" then
		data, request = httpGet(
			"robloxGetUserFromId",
			query.urlencode(value)
		)
	end

	local decode = json.decode(request)

	return assert(
		decode,
		"Unable to decode apiRobloxGetUser"
	)
end

return apiRobloxGetUser
