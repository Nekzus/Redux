function apiGoogleTranslateLangs(lang)
	local data, request = httpGet("googleTranslateLangs", {config.apiKeys.googleTranslateKey, lang})
	local decoded = json.decode(request)

	if not decoded then
		print("unable to decode apiGoogleTranslateLangs()")

		return nil
	end

	local data = decoded.data
	local list = data and data.languages

	return list or false
end

return apiGoogleTranslateLangs
