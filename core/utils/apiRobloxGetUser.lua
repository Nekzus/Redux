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
		data, request = httpGet("robloxGetUserFromName", {value})
	elseif method == "id" then
		data, request = httpGet("robloxGetUserFromId", {value})
	end

	local decode = json.decode(request)

	if not decode then
		print("Unable to decode apiRobloxGetUser()")

		return nil
	end

	return decode
end

return apiRobloxGetUser
