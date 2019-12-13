function apiGoogleSearch(text)
	local data, request = httpGet(
		"googleSearch",
		config.apiKeys.googleSearchKey,
		config.apiKeys.googleSearchCx,
		text
	)
	local decoded = json.decode(request)

	return assert(
		decoded,
		"Unable to decode apiGoogleSearch"
	)
end

return apiGoogleSearch
