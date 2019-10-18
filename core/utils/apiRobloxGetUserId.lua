function apiRobloxGetUserId(name)
	local data, request = httpGet("robloxGetUserId", name)
	local decode = json.decode(request)

	if not decode then
		print("Unable to decode apiRobloxGetUserId()")

		return nil
	end

	return {
		id = decode.Id,
		username = decode.Username,
		isOnline = decode.IsOnline
	}
end

return apiRobloxGetUserId
