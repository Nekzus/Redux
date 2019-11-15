local _config = {
	name = "useitem",
	desc = "${usesItemFromInventory}",
	usage = "${nameKey}",
	aliases = {"use"},
	cooldown = 2,
	level = 0,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
		local args = data.args

	if not (args[2]) then
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local itemName = data.content:sub(#args[1] + 2)
	local memberEconomy, guildEconomy = getMemberEconomy(data.user, data.guild)
	local memberCash = memberEconomy:get("cash", 0)
	local memberBank = memberEconomy:get("bank", 0)
	local memberInventory = memberEconomy:get("inventory", {})
	local guildInventory = guildEconomy:get("store", {})
	local itemLocalData
	local itemStoreData

	for itemGuid, item in next, memberInventory:raw() do
		local storeItem = guildInventory:raw()[itemGuid]

		if storeItem and storeItem.itemName:lower() == itemName:lower() then
			itemLocalData = item
			itemStoreData = storeItem
		end
	end

	if not (itemLocalData and itemStoreData) then
		local text = localize("${itemNotFoundName}", guildLang)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	if itemLocalData.itemAmount <= 0 then
		local text = localize("${itemDoesNotHave}", guildLang)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	else
		itemLocalData.itemAmount = itemLocalData.itemAmount - 1
		memberInventory:set(itemStoreData.guid, itemLocalData)
	end

	local reqRoleId = itemStoreData.reqRole
	local reqRole = reqRoleId and getRole(reqRoleId, "id", data.guild)

	if reqRoleId and reqRole then
		if not data.member:hasRole(reqRoleId) then
			local text = localize("${itemUseMustHaveRole}", guildLang, reqRole.name)
			local embed = replyEmbed(text, data.message, "warn")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end

	local giveRoleId = itemStoreData.giveRole
	local giveRole = giveRoleId and getRole(giveRoleId, "id", data.guild)

	if giveRoleId and giveRole then
		if not data.member:hasRole(giveRoleId) then
			data.member:addRole(giveRoleId)
		end
	end

	local giveCash = itemStoreData.giveCash

	if giveCash and giveCash > 0 then
		memberCash = memberEconomy:set("cash", memberCash + giveCash)
	end

	local text = localize("${inventoryItemUsed}", guildLang)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
