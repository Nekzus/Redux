function apiGoogleSearch(text)
	local data, request = httpGet("googleSearch", {config.keys.googleSearchKey, config.keys.googleSearchCx, text})
	local decoded = json.decode(request)

	if not decoded then
		print("unable to decode apiGoogleSearch()")

		return nil
	end

	return decoded
end

return apiGoogleSearch