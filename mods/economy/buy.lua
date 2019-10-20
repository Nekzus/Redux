local _config = {
	name = "buy",
	desc = "${buysItemFromStore}",
	usage = "${nameKey}",
	aliases = {},
	cooldown = 2,
	level = 0,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	if not (args[2] and args[3]) then
		local text = parseFormat("${missingArg}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local itemName
	local buyAmount = tonumber(args[2])

	if buyAmount == nil then
		buyAmount = 1
		itemName = data.content:sub(#args[1] + 2)
	elseif (type(buyAmount) == "number" and buyAmount < 1) then
		local text = parseFormat("${missingArg}: buyAmount", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	else
		itemName = data.content:sub(#args[1] + #args[2] + 3)
	end

	local itemData = getStoreItem(itemName, data.guild)

	if not itemData then
		local text = parseFormat("${itemNotFoundName}", langList)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local memberEconomy, guildEconomy = getMemberEconomy(data.user, data.guild)
	local memberCash = memberEconomy:get("cash", 0)
	local memberBank = memberEconomy:get("bank", 0)
	local memberTotal = memberCash + memberBank
	local member = data.guild:getMember(data.author)
	local symbol = guildEconomy:get("symbol")

	local guid = itemData.guid
	local itemName = itemData.itemName
	local itemPrice = itemData.itemPrice
	local itemStock = itemData.itemStock
	local buyTotal = itemPrice * buyAmount

	if itemStock == 0 then
		local text = parseFormat("${storeItemOutStock}", langList)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif itemStock ~= -1 then
		if buyAmount > itemStock then
			local text = parseFormat("${stockItemBuyMax}", langList, itemStock)
			local embed = replyEmbed(text, data.message, "warn")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end

	if buyTotal > memberTotal then
		local text = parseFormat("${storeItemCashNeeded}", langList, format("%s %s", symbol, buyTotal - memberTotal))
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local pendingPrice = buyTotal

	while pendingPrice > 0 do
		if memberCash > 0 then
			if memberCash >= pendingPrice then
				memberCash = memberEconomy:set("cash", memberCash - pendingPrice)
				pendingPrice = 0
			else
				memberCash = memberEconomy:set("cash", 0)
				pendingPrice = pendingPrice - memberCash
			end
		elseif memberBank > 0 then
			if memberBank >= pendingPrice then
				memberBank = memberEconomy:set("bank", memberBank - pendingPrice)
				pendingPrice = 0
			else
				memberBank = memberEconomy:set("bank", 0)
				pendingPrice = pendingPrice - memberBank
			end
		else
			break
		end
	end

	if itemStock ~= -1 then
		itemData.itemStock = max(0, itemData.itemStock - buyAmount)
	end

	local memberInventory = memberEconomy:get("inventory")
	local itemExists = memberInventory:raw()[itemData.guid]

	if itemExists then
		itemExists.itemAmount = itemExists.itemAmount + buyAmount
		memberInventory:set(itemData.guid, itemExists)
	else
		local newItemData = {
			guid = guid,
			itemAmount = buyAmount,
		}

		memberInventory:set(guid, newItemData)
	end

	local text = parseFormat("${successBoughtItem}", langList)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
