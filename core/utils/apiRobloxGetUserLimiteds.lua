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
	local data, request = httpGet("robloxGetUserCollectibles", {id})
	local decode = json.decode(request)

	if not decode then
		print("Unable to decode apiRobloxGetUserHeadShot()")

		return nil
	end

	return decode
end

return apiRobloxGetUserHeadShot
