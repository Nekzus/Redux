function apiAscii(text, font)
	local data, request = httpGet(
		"asciiMake",
		query.urlencode(text),
		query.urlencode(font or "standard")
	)

	local decoded = json.decode(request)

	return assert(
		decoded,
		"Unable to decode apiAscii"
	)
end

return apiAscii
