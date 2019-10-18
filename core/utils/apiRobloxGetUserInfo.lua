function apiRobloxGetUserInfo(id)
	local data, request = httpGet("robloxGetUserInfo", id)
	local decode = json.decode(request)

	if not decode then
		print("Unable to decode apiRobloxGetUserInfo()")

		return nil
	end

	return {
		id = decode.Id,
		username = decode.Username,
		isOnline = decode.IsOnline
	}
end

return apiRobloxGetUserInfo
