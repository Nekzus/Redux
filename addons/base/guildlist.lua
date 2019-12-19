local _config = {
	name = "guildlist",
	desc = "${showsGlobalGuildsList}",
	usage = "${pageKey}",
	aliases = {"guilds", "glist", "gs"},
	cooldown = 0,
	level = 5,
	direct = true,
	perms = {"addReactions", "manageMessages"},
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	local listItems = client.guilds:toArray() --{}
	local listTotal = #listItems

	local perPage = 10
	local page = tonumber(args[2]) or 1

	local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuild)
	local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuild)
	local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuild)

	local decoy
	local message

	local function showPage()
		local embed = newEmbed()
		local inPage = 0
		local result = ""

		table.sort(listItems, function(a, b)
			return #a.members < #b.members
		end)

		for _, obj in next, paginate(listItems, perPage, page) do
			inPage = inPage + 1

			if result ~= "" then
				result = string.format("%s\n", result)
			end

			local guildName = obj.name:gsub("[\128-\255]", "")

			if #guildName > 15 then
				guildName = string.format("%s...", guildName:sub(1, 12))
			end

			result = localize("%s%s **%s**: `%s`", guildLang, result, topicEmoji.mentionString, guildName, obj.id)
		end

		local pages = listTotal / perPage

		if tostring(pages):match("%.%d+") then
			pages = math.max(1, tonumber(tostring(pages):match("%d+") + 1))
		end

		embed:title(localize("${guilds} (%s/%s) [${page} %s/%s]", guildLang, inPage, listTotal, page, pages))
		embed:description(result ~= "" and result or localize("${noResults}", guildLang))

		embed:color(paint.info)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		if listTotal <= perPage then
			if decoy == nil then
				decoy = bird:post(nil, embed:raw(), data.channel)
			else
				decoy:update(nil, embed:raw())
			end

			return true
		end

		if decoy == nil then
			decoy = bird:post(nil, embed:raw(), data.channel)
			blinker = blink(decoy:getMessage(), config.timeouts.reaction, {data.user.id})

			blinker:on(arwDown.id, function()
				page = math.min(pages, page + 1)

				if not private then
					decoy:removeReaction(arwDown, data.user.id)
				end

				showPage()
			end)

			blinker:on(arwUp.id, function()
				page = math.max(1, page - 1)

				if not private then
					decoy:removeReaction(arwUp, data.user.id)
				end

				showPage()
			end)

			decoy:addReaction(arwDown)
			decoy:addReaction(arwUp)
		else
			decoy:update(nil, embed:raw())
		end
	end

	showPage()

	return true
end

return {config = _config, func = _function}
