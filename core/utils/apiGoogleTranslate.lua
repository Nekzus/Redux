function apiGoogleTranslate(lang, text)
	local data, request = httpGet("googleTranslate", {config.keys.googleTranslateKey, lang, text})
	local decoded = json.decode(request)

	if not decoded then
		print("unable to decode apiGoogleTranslate()")

		return nil
	end

	return decoded
end

return apiGoogleTranslate
