local _config = {
	name = "giveitem",
	desc = "${givesItemToSomeone}",
	usage = "${numKey} \"${nameKey}\" ${userKey}",
	aliases = {"give"},
	cooldown = 2,
	level = 3,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	if not (args[2]) then
		local text = parseFormat("${missingArg}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false
	end

	if not specifiesUser(data.message) then
		local text = parseFormat("${specifyUser}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false

	elseif mentionsBot(data.message) then
		local text = parseFormat("${noExecuteBot}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false

	elseif mentionsOtherBot(data.message) then
		local text = parseFormat("${noExecuteOtherBot}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false
	end

	local giveAmount = tonumber(args[2])

	if giveAmount == nil then
		giveAmount = 1
	elseif (type(giveAmount) == "number" and giveAmount < 1) then
		local text = parseFormat("${missingArg}: giveAmount", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local itemName = data.message.content:match(config.patterns.quotes.capture)
	local itemData = itemName and getStoreItem(itemName, data.guild)

	if not itemData then
		local text = parseFormat("${itemNotFoundName}", langList)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local users = data.message.mentionedUsers:toArray()

	for _, user in next, users do
		local memberEconomy, guildEconomy = getMemberEconomy(user, data.guild)

		local guid = itemData.guid
		local itemName = itemData.itemName

		local memberInventory = memberEconomy:get("inventory")
		local itemExists = memberInventory:raw()[itemData.guid]

		if itemExists then
			itemExists.itemAmount = itemExists.itemAmount + giveAmount
			memberInventory:set(itemData.guid, itemExists)
		else
			local newItemData = {
				guid = guid,
				itemAmount = giveAmount,
			}

			memberInventory:set(guid, newItemData)
		end
	end

	local text = parseFormat("${successGaveItem}", langList)
	local embed = replyEmbed(text, data.message, "ok")

	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
