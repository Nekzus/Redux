function apiGoogleSearch(text)
	local data, request = httpGet("googleSearch", {config.keys.googleKey, config.keys.googleCx, text})
	local decoded = json.decode(request)

	if not decoded then
		return nil, print("unable to decode apiGoogleSearch()")
	end

	return decoded
end

return apiGoogleSearch
