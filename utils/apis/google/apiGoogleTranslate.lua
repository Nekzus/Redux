function apiGoogleTranslate(lang, text)
	local data, request = httpGet(
		"googleTranslate",
		config.apiKeys.googleTranslateKey,
		lang,
		query.urlencode(text)
	)

	local decoded = json.decode(request)

	return assert(
		decoded,
		"Unable to decode apiGoogleTranslate"
	)
end

return apiGoogleTranslate
