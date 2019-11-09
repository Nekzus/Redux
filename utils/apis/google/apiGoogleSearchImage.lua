function apiGoogleSearchImage(text)
	local data, request = httpGet("googleSearchImage", {config.apiKeys.googleSearchKey, config.apiKeys.googleSearchCx, text})
	local decoded = json.decode(request)

	if not decoded then
		print("unable to decode apiGoogleSearchImage()")

		return nil
	end

	return decoded
end

return apiGoogleSearchImage
