local _config = {
	name = "inventory",
	desc = "${buysItemFromStore}",
	usage = "${nameKey}",
	aliases = {"inv", "stuff"},
	cooldown = 2,
	level = 5
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local memberEconomy, guildEconomy = getMemberEconomy(data.user, data.guild)
	local memberInventory = memberEconomy:get("inventory")
	local guildInventory = guildEconomy:get("store")

	local listTotal = 0
	local listItems = {}

	for itemGuid, item in pairs(memberInventory:raw()) do
		local itemData = guildInventory:raw()[itemGuid]

		insert(listItems, {
			name = itemData.itemName,
			desc = itemData.itemDesc,
			amount = item.itemAmount,
		})
		listTotal = listTotal + 1
	end

	return true
end

return {config = _config, func = _function}
