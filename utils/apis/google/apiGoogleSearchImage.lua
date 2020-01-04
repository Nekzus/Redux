function apiGoogleSearchImage(text)
	local data, request = httpGet(
		"googleSearchImage",
		config.apiKeys.googleSearchKey,
		config.apiKeys.googleSearchCx,
		query.urlencode(text)
	)

	local decoded = json.decode(request)

	return assert(
		decoded,
		"Unable to decode apiGoogleSearchImage"
	)
end

return apiGoogleSearchImage
