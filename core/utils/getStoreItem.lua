function getStoreItem(guild, value)
	local guildData = getGuildEconomy(guild)
	local guildStore = guildData:get("store")

	value = value:lower()

	for itemGuid, itemData in next, guildStore:raw() do
		if itemGuid:lower() == value or itemData.itemName:lower() == value then
			return itemData
		end
	end

	return false
end

return getStoreItem
