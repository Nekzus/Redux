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

	local perPage = 10
	local page = tonumber(args[2]) or 1

	local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuild)
	local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuild)
	local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuild)

	local decoyBird
	local message

	local function showPage()
		local embed = newEmbed()
		local count = 0
		local result = ""

		local rList = client.guilds:toArray()
		local nCount = #rList

		sort(rList, function(a, b)
			return a.name < b.name
		end)

		for _, obj in next, paginate(rList, perPage, page) do
			count = count + 1

			if result ~= "" then
				result = format("%s\n", result)
			end

			local guildName = obj.name

			if #guildName > 15 then
				guildName = format("%s...", sub(guildName, 1, 18))
			end

			result = localize("%s%s **%s**: `%s`", guildLang, result, topicEmoji.mentionString, guildName, obj.id)
		end

		local pages = nCount / perPage

		if tostring(pages):match("%.%d+") then
			pages = max(1, tonumber(tostring(pages):match("%d+") + 1))
		end

		embed:title(localize("${guilds} (%s/%s) [${page} %s/%s]", guildLang, count, nCount, page, pages))
		embed:description(result ~= "" and result or localize("${noResults}", guildLang))

		embed:color(paint("blue")
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		if nCount <= perPage then
			decoyBird = decoyBird == nil and bird:post(nil, embed:raw(), data.channel)
			or decoyBird:update(nil, embed:raw())

			return true
		end

		if decoyBird == nil then
			decoyBird = bird:post(nil, embed:raw(), data.channel)
			blinker = blink(decoyBird:getMessage(), config.timeouts.reaction, {data.user.id})

			blinker:on(arwDown.id, function()
				page = min(pages, page + 1)

				if not private then
					decoyBird:removeReaction(arwDown, data.user.id)
				end

				showPage()
			end)

			blinker:on(arwUp.id, function()
				page = max(1, page - 1)

				if not private then
					decoyBird:removeReaction(arwUp, data.user.id)
				end

				showPage()
			end)

			decoyBird:addReaction(arwDown)
			decoyBird:addReaction(arwUp)
		else
			decoyBird:update(nil, embed:raw())
		end
	end

	showPage()

	return true
end

return {config = _config, func = _function}
