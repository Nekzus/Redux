function apiUrban()
	local data, request = httpGet("urbanDictionary")
	local decode = json.decode(request)

	if not decode then
		print("Unable to decode apiUrban()")

		return nil
	end

	return json.decode(request)
end

return apiUrban
