function apiYoutubeVideo(text)
	local data, request = httpGet("youtubeSearch", {config.keys.youtubeKey, text})
	local decoded = json.decode(request)

	if not decoded then
		return nil, print("unable to decode apiYoutubeVideo()")
	end

	return decoded
end

return apiYoutubeVideo
