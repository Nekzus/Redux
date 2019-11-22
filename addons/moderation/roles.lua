local _config = {
	name = "roles",
	desc = "${listsDefinedRoles}",
	usage = "",
	aliases = {"rls"},
	cooldown = 0,
	level = 5, -- 3
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	local guildRoles = guildData:get("roles")

	local listTotal = 0
	local listItems = {}

	for roleId, obj in pairs(guildRoles:raw()) do
		local roleExists = getRole(roleId, "id", data.guild)

		if roleExists then
			local isPrimary = getPrimaryRoleIndex(obj.level, guildRoles:raw()) == roleId

			insert(listItems, {
				id = roleId,
				level = obj.level,
				primary = isPrimary,
				added = obj.added
			})
			listTotal = listTotal + 1
		end
	end

	sort(listItems, function(a, b)
		return a.level > b.level or (a.level == b.level and a.added > b.added)
	end)

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

		for _, obj in next, paginate(listItems, perPage, page) do
			inPage = inPage + 1

			if result ~= "" then
				result = result .. "\n"
			end

			local roleTitle = getMatchingRoleTitle(obj.level)

			result = format("%s%s %s@%s: `%s`", result, topicEmoji.mentionString, obj.primary and localize("**[${initial}]** ", guildLang) or "", getRole(obj.id, "id", data.guild).name, (obj.level and roleTitle and localize(roleTitle, guildLang)))
		end

		local pages = listTotal / perPage

		if tostring(pages):match("%.%d+") then
			pages = max(1, tonumber(tostring(pages):match("%d+") + 1))
		end

		embed:title(localize("${roles} (%s/%s) [${page} %s/%s]", guildLang, inPage, listTotal, page, pages))
		embed:description(result ~= "" and result or localize("${noResults}", guildLang))

		embed:color(paint("blue"))
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
				page = min(pages, page + 1)

				if not private then
					decoy:removeReaction(arwDown, data.user.id)
				end

				showPage()
			end)

			blinker:on(arwUp.id, function()
				page = max(1, page - 1)

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
