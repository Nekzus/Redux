function httpHandle(method, link, ...)
	local args = {...}
	local link = config.apiPoints[apiName] or point

	if args[1] then
		link = string.format(link, ...)
	end

	return http.request(method, link)
end

return httpHandle
