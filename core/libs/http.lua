function httpHandle(method, api, param, ...)
	local point
	local link = config.api[api]

	if access then
		if param then
			point = format(link, unpack(param))
		else
			point = link
		end
	end

	return http.request(method, point, ...)
end

function httpPost(api, param, ...)
	return httpHandle("POST", api, param, ...)
end

function httpGet(api, param, ...)
	return httpHandle("GET", api, param, ...)
end

return true
