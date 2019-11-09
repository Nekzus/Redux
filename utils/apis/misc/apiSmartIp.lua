function apiSmartIp(text)
	local data, request = httpGet("smartIp", {config.apiKeys.smartIpKey, text})
	local decode = json.decode(request)

	if not decode then
		print("Unable to decode apiSmartIp()")

		return nil
	end

	return json.decode(request)
end

return apiSmartIp
