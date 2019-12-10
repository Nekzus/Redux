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
	local data, request = httpGet("robloxGetUserPrimaryGroup", {value})
	local decode = json.decode(request)

	if not decode then
		print("Unable to decode apiRobloxGetUserPrimaryGroup()")

		return nil
	end

	return decode and decode.group or false
end

return apiRobloxGetUserPrimaryGroup
