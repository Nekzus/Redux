function apiGoogleSearch(text)
	local data, request = httpGet(
		"googleSearch",
		config.apiKeys.googleSearchKey,
		config.apiKeys.googleSearchCx,
		query.urlencode(text)
	)
	local decoded = json.decode(request)

	return assert(
		decoded,
		"Unable to decode apiGoogleSearch"
	)
end

return apiGoogleSearch
