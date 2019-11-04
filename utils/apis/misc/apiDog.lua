function apiDog()
	local data, request = httpGet("dogImage")
	local decode = json.decode(request)

	if not decode then
		return nil, print("Unable to decode apiDog()")
	end

	return json.decode(request).message
end

return apiDog
