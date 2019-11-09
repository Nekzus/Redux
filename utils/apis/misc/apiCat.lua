function apiCat()
	local data, request = httpGet("catImage")
	local decode = json.decode(request)

	if not decode then
		print("Unable to decode apiCat()")

		return nil
	end

	return json.decode(request).file
end

return apiCat
