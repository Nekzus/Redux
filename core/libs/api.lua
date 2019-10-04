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

function httpHandle(method, endPoint, param, ...)
	local point
	local link = api[endPoint]

	if access then
		if param then
			point = format(link, unpack(param))
		else
			point = link
		end
	end

	return http.request(method, point, ...)
end

function httpPost(endPoint, param, ...)
	return httpHandle("POST", endPoint, param, ...)
end

function httpGet(endPoint, param, ...)
	return httpHandle("GET", endPoint, param, ...)
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
	local data, request = httpGet("googleSearch", {apiData.googleKey, apiData.googleCx, text})
	local decoded = json.decode(request)

	if not decoded then
		return nil, print("unable to decode googleSearchApi()")
	end

	return decoded
end

function youtubeVideoApi(text)
	local data, request = httpGet("youtubeSearch", {apiData.youtubeKey, text})
	local decoded = json.decode(request)

	if not decoded then
		return nil, print("unable to decode youtubeVideoApi()")
	end

	return decoded
end

function screenshareApi(guildId, voiceId)
	assert(guildId, "Missing guild ID")
	assert(voiceId, "Missing voice ID")

	return format(api.discordScreenshare, guildId, voiceId)
end

return true
