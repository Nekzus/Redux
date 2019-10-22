function apiTruth()
	local data, request = httpGet("truthYesNo")
	local decode = json.decode(request)

	if not decode then
		return nil, print("Unable to decode apiTruth()")
	end

	return decode.answer, decode.image, decode.forced
end

return apiTruth
