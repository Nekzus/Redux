local api = {
	catImage = "https://aws.random.cat/meow",
	dogImage = "https://dog.ceo/api/breeds/image/random",
	youtubeSearch = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&order=date&type=video&key=%s&q=%s",
	googleSearch = "https://www.googleapis.com/customsearch/v1?key=%s&cx=%s&q=%s",
	truthYesNo = "https://yesno.wtf/api",
	truthYesNoForce = "https://yesno.wtf/api?force=%s",
	discordScreenshare = "https://discordapp.com/channels/%s/%s",
}

local apiData = {
	youtubeKey = "AIzaSyApllT_5QSRx-JnNJF8TNcDZRSSKm3cBCE",
	googleKey = "AIzaSyDENwT8E_qHRpzrI6eLHANOAvLHy_WiyBo",
	googleCx = "000898645152450243880:ypizs90acrv",
}

function httpPost(endPoint, option, param, ...)
	local point
	local link = api[endPoint]

	if access then
		if param then
			point = format(link, unpack(param))
		else
			point = link
		end
	end

	return http.request("POST", point, ...)
end

function httpGet(endPoint, option, param, ...)
	local point
	local link = api[endPoint]

	if access then
		if param then
			point = format(link, unpack(param))
		else
			point = link
		end
	end

	return http.request("GET", point, ...)
end

function catApi()
	local data, request = httpGet("catImage")
	local decode = json.decode(request)

	if not decode then
		return nil, print("Unable to decode catApi()")
	end

	return json.decode(request).file
end

function dogApi()
	local data, request = httpGet("dogImage")
	local decode = json.decode(request)

	if not decode then
		return nil, print("Unable to decode dogApi()")
	end

	return json.decode(request).message
end

function truthApi(text)
	local data, request
	local choice = text:find("-y") and "yes"
	or text:find("-n") and "no"
	or text:find("-m") and "maybe"

	if choice then
		data, request = httpGet("truthYesNoForce", {choice})
	else
		data, request = httpGet("truthYesNo")
	end

	local decode = json.decode(request)

	if not decode then
		return nil, print("Unable to decode truthApi()")
	end

	return decode.answer, decode.image, decode.forced
end

function googleSearchApi(text)
	local result = ""

	for _, word in next, text:split(" ") do
		if result ~= "" then
			result = format("%s%+", result)
		end

		result = format("%s%s", result, word)
	end

	local data, request = httpGet("googleSearch", {_config.googleKey, _config.googleCx, text})
	local decoded = json.decode(request)

	return decoded
end

function youtubeApi(text)
	local data, request = httpGet("youtubeSearch", {_config.youtube.key, text})
	local decoded = json.decode(request)

	if not decoded then
		return nil, print("unable to decode youtubeApi()")
	end

	return decoded
end

function screenShareApi(guildId, voiceId)
	assert(guildId, "Missing guild ID")
	assert(voiceId, "Missing voice ID")

	return format(api.discordScreenshare, guildId, voiceId)
end

return true
