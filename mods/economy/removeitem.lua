local _config = {
	name = "removeitem",
	desc = "${removesItemFromStore}",
	usage = "",
	aliases = {"ri", "deleteitem", "di"},
	cooldown = 0,
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

	local guildEconomy = getGuildEconomy(data.guild.id)
	local guildStore = guildEconomy:get("store", {})
	local value = data.content:sub(#args[1] + 2)

	for itemGuid, item in next, guildStore:raw() do
		if item.itemName:lower() == value:lower() then
			local text = parseFormat("${itemDeletedFromStore}", langList)
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)
			guildStore:set(itemGuid, nil)

			return true
		end
	end

	local text = parseFormat("${itemNotFoundName}", langList)
	local embed = replyEmbed(text, data.message, "warn")

	bird:post(nil, embed:raw(), data.channel)

	return false
end

return {config = _config, func = _function}
