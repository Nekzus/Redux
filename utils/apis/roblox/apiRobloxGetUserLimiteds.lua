--[[
	{
		"previousPageCursor": "null",
		"nextPageCursor": null,
		"data": [
			{
				"userAssetId": 510938272,
				"serialNumber": 149,
				"assetId": 48159815,
				"name": "Shadow Dancer",
				"recentAveragePrice": 5109,
				"originalPrice": 2000,
				"assetStock": 500,
				"buildersClubMembershipType": 0
			},
			{
				"userAssetId": 470222774,
				"serialNumber": 966,
				"assetId": 44561064,
				"name": "Noob Attack:  Luchador Liability",
				"recentAveragePrice": 873,
				"originalPrice": 75,
				"assetStock": 2000,
				"buildersClubMembershipType": 0
		},
	]
]]

function apiRobloxGetUserLimiteds(id, amount)
	local result = {}
	local nextPage = ""

	amount = amount or 100

	while true do
		local data, request = httpGet(
			"robloxGetUserCollectibles",
			query.urlencode(id),
			query.urlencode(amount),
			query.urlencode(nextPage)
		)

		local decode = json.decode(request)

		if not decode then
			client:error("Unable to decode apiRobloxGetUserLimiteds")
			break
		elseif not decode.data then
			break
		end

		for _, tab in next, decode.data do
			table.insert(result, tab)
		end

		if decode.nextPageCursor and amount == 100 then
			nextPage = decode.nextPageCursor
		else
			break
		end
	end

	return result
end

return apiRobloxGetUserLimiteds
