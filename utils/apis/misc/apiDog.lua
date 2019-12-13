function apiDog()
	local data, request = httpGet(
		"dogImage"
	)

	local decoded = json.decode(request)
	local message = decoded and decoded.message

	return assert(
		message,
		"Unable to decode apiDog"
	)
end

return apiDog
