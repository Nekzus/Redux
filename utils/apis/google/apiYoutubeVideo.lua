function apiYoutubeVideo(text)
	local data, request = httpGet(
		"youtubeSearch",
		config.apiKeys.youtubeVideoKey,
		text
	)

	local decoded = json.decode(request)

	return assert(
		decoded,
		"Unable to decode apiYoutubeVideo"
	)
end

return apiYoutubeVideo
