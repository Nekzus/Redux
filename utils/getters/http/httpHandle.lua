function httpHandle(method, point, ...)
	assert(method, "Must provide a valid method (GET or POST)")
	assert(point, "Must provide a valid point")

	local args = {...}
	local link = config.apiPoints[point] or point

	if args[1] then
		link = string.format(link, ...)
	end

	return http.request(method, link)
end

return httpHandle
