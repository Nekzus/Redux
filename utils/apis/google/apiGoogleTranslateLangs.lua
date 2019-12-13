function apiGoogleTranslateLangs(lang)
	local data, request = httpGet(
		"googleTranslateLangs",
		config.apiKeys.googleTranslateKey,
		lang
	)
	local decoded = json.decode(request)
	local data = decoded and decoded.data
	local list = data and data.languages

	return assert(
		list,
		"Unable to decode apiGoogleTranslateLangs"
	)
end



return apiGoogleTranslateLangs
