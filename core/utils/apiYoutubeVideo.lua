function apiYoutubeVideo(text)
	local data, request = httpGet("youtubeSearch", {config.keys.youtubeVideoKey, text})
	local decoded = json.decode(request)

	if not decoded then
		print("unable to decode apiYoutubeVideo()")

		return nil
	end

	return decoded
end

return apiYoutubeVideo
