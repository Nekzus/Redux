function apiCat()
	local data, request = httpGet(
		"catImage"
	)

	local decoded = json.decode(request)
	local file = decoded and decoded.file

	return assert(
		file,
		"Unable to decode apiCat"
	)
end

return apiCat
