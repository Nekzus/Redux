function apiSmartIp(text)
	local data, request = httpGet(
		"smartIp",
		query.urlencode(text),
		config.apiKeys.smartIpKey
	)

	local decoded = json.decode(request)

	return assert(
		decoded,
		"Unable to decode apiSmartIp"
	)
end

return apiSmartIp
