function httpRequest(method, link, ...)
	return http.request(method, string.format(link, ...))
end

return httpRequest
