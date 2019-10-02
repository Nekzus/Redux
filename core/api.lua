local apis = {
	cat = {
		main = "https://aws.random.cat/meow",
	},

	dog = {
		main = "https://dog.ceo/api/breeds/image/random",
	},

	youtube = {
		search = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&order=date&type=video&key=%s&q=%s",
	},

	google = {
		search = "https://www.googleapis.com/customsearch/v1?key=%s&cx=%s&q=%s",
	},

	yesno = {
		main = "https://yesno.wtf/api",
		force = "https://yesno.wtf/api?force=%s",
	},

	discord = {
		screenShare = "https://discordapp.com/channels/%s/%s"
	},
}

local _config = {
	youtube = {
		key = "AIzaSyApllT_5QSRx-JnNJF8TNcDZRSSKm3cBCE",
	},

	googleSearch = {
		key = "AIzaSyDENwT8E_qHRpzrI6eLHANOAvLHy_WiyBo",
		cx = "000898645152450243880:ypizs90acrv",
	}
}

function httpPost(endPoint, option, param, ...)
	local point
	local link = apis[endPoint]
	local access = link and link[option]

	if access then
		if param then
			point = format(access, unpack(param))
		else
			point = access
		end
	end

	return http.request("POST", point, ...)
end

function httpGet(endPoint, option, param, ...)
	local point
	local link = apis[endPoint]
	local access = link and link[option]

	if access then
		if param then
			point = format(access, unpack(param))
		else
			point = access
		end
	end

	return http.request("GET", point, ...)
end

function catApi()
	local data, request = httpGet("cat", "main")
	local decode = json.decode(request)

	if not decode then
		return nil, print("Unable to decode catApi()")
	end

	return json.decode(request).file
end

function dogApi()
	local data, request = httpGet("dog", "main")
	local decode = json.decode(request)

	if not decode then
		return nil, print("Unable to decode dogApi()")
	end

	return json.decode(request).message
end

-- https://yesno.wtf/#api
function truthApi(text)
	local data, request
	local choice = text:find("-y") and "yes"
	or text:find("-n") and "no"
	or text:find("-m") and "maybe"

	if choice then
		data, request = httpGet("yesno", "force", {choice})
	else
		data, request = httpGet("yesno", "main")
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

	local key = _config.googleSearch.key
	local cx = _config.googleSearch.cx
	local data, request = httpGet("google", "search", {key, cx, text})
	local decoded = json.decode(request)

	return decoded
end

function youtubeApi(text)
	local key = _config.youtube.key
	local data, request = httpGet("youtube", "search", {key, text})
	local decoded = json.decode(request)

	if not decoded then
		return nil, print("unable to decode apis.search:youtubeSearch()")
	end

	return decoded
end

function screenShareApi(guildId, voiceId)
	assert(guildId, "Missing guild ID")
	assert(voiceId, "Missing voice ID")

	return format(apis.discord.screenShare, guildId, voiceId)
end
