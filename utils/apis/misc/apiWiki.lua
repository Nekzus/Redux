function apiWiki(text, lang)
	local data, request = httpGet("wikipedia", {lang or "en", text})
	local decode = json.decode(request)

	if not decode then
		print("Unable to decode apiWiki()")

		return nil
	end

	return {
		search = decode[1],
		result = decode[2][1],
		definition = decode[3][1],
		link = decode[4][1]
	}
end

return apiWiki
