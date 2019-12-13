--[[
	{
		"Id": 110839429,
		"Username": "Nekzus",
		"AvatarUri": null,
		"AvatarFinal": false,
		"IsOnline": false
	}
]]

function apiRobloxGetUserPrimaryGroup(value)
	local data, request = httpGet(
		"robloxGetUserPrimaryGroup",
		value
	)

	local decoded = json.decode(request)

	assert(decoded, "Unable to decode apiRobloxGetUserPrimaryGroup")

	return decoded and decoded.group or false
end

return apiRobloxGetUserPrimaryGroup
