--[[
	{
		"PlayerAvatars": [
			{
				"Thumbnail": {
					"Final": true,
					"Url": "https://tr.rbxcdn.com/018f84ec2c4d2f304c4ad81e1bbe15dd/100/100/Avatar/Png",
					"RetryUrl": null,
					"UserId": 110839429,
					"EndpointType": "Avatar"
				},
				"UserId": 110839429
			}
		]
	}
]]

function apiRobloxGetUserHeadShot(id, headShot)
	if headShot == true or headShot == "true" then
		headShot = "true"
	elseif headShot == false or headShot == "false" then
		headShot = "false"
	else
		headShot = "false"
	end

	local data, request = httpGet("robloxGetUserHeadShot", {headShot, id})
	local decode = json.decode(request)

	if not decode then
		print("Unable to decode apiRobloxGetUserHeadShot()")
		return nil
	end

	return decode
end

return apiRobloxGetUserHeadShot