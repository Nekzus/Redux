function apiTruth(text)
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
		return nil, print("Unable to decode apiTruth()")
	end

	return decode.answer, decode.image, decode.forced
end

return apiTruth
