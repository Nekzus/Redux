local _config = {
	name = "help",
	desc = "${helpMessage}",
	usage = "${nameKey}",
	aliases = {"h", "commands", "cmds"},
	cooldown = 5,
	level = 0,
	direct = true,
	perms = {"addReactions", "manageMessages"},
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local userLevel = not private and getMemberLevel(data.user, data.guild) or 0
	local value = args[2] and args[2]:lower()

	local command = value and inList(value, commands.list)
	local category = value and inList(value, commands.categories)

	local baseEmoji = getEmoji(config.emojis.book, "name", baseGuildId)
	local economyEmoji = getEmoji(config.emojis.twoMoney, "name", baseGuildId)
	local entertainmentEmoji = getEmoji(config.emojis.balloons, "name", baseGuildId)
	local moderationEmoji = getEmoji(config.emojis.shield, "name", baseGuildId)

	local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuildId)

	local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuildId)
	local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuildId)
	local arwLeft = getEmoji(config.emojis.arwLeft, "name", baseGuildId)
	local arwRight = getEmoji(config.emojis.arwRight, "name", baseGuildId)

	local active = true
	local decoyBird
	local blinker

	local menuSwaping
	local renderCategory
	local renderMenu

	menuSwaping = function()
		active = false
		blinker:clear()
		decoyBird:clearReacts()
	end

	renderCategory = function(category)
		local listTotal = 0
		local listItems = {}

		for commandName, command in pairs(commands.list) do
			if not command.alias and not isCommandRestrict(command, guildLang) and command.category:match(category) then
				data.command = format("%s%s", data.prefix, command.name)

				local permit, patronCommand = canRunCommand(data)

				if permit then
					insert(listItems, {name = commandName, data = command})
					listTotal = listTotal + 1
				end
			end
		end

		sort(listItems, function(a, b)
			return a.name < b.name
		end)

		local perPage = 8
		local page = tonumber(args[2]) or 1
		local pages = listTotal / perPage
		local message

		local function showPage()
			local embed = newEmbed()
			local inPage = 0
			local result = ""

			local embed = newEmbed()

			embed:title(client.user.name)
			embed:description(parseFormat("${botDesc}", langList, client.user.name))

			embed:color(config.colors.blue)
			embed:footerIcon(config.images.info)
			signFooter(embed, data.author, guildLang)

			for _, command in next, paginate(listItems, perPage, page) do
				inPage = inPage + 1

				if result ~= "" then
					result = format("%s\n", result)
				end

				if command.data.usage == "" or command.data.usage == nil then
					result = format("%s%s**%s** %s", result, topicEmoji.mentionString, command.name, parseFormat(command.data.desc, langList))
				else
					result = format("%s%s**%s** `%s` %s", result, topicEmoji.mentionString, command.name, parseFormat(command.data.usage, langList), parseFormat(command.data.desc, langList))
				end
			end

			if tostring(pages):match("%.%d+") then
				pages = max(1, tonumber(tostring(pages):match("%d+") + 1))
			end

			embed:field({
				name = parseFormat("${commands} (%s/%s) [${page} %s/%s]", langList, inPage, listTotal, page, pages),
				value = (result ~= "" and result or parseFormat("${noResults}", langList)), inline = true
			})

			embed:color(config.colors.blue)
			embed:footerIcon(config.images.info)
			signFooter(embed, data.author, guildLang)

			if listTotal <= perPage then
				decoyBird = decoyBird == nil and bird:post(nil, embed:raw(), data.channel)
				or decoyBird:update(nil, embed:raw())

				return true
			end

			if decoyBird == nil then
				decoyBird = bird:post(nil, embed:raw(), data.channel)
			else
				decoyBird:update(nil, embed:raw())
			end
		end

		showPage()

		decoyBird:addReaction(arwLeft)
		decoyBird:addReaction(arwDown)
		decoyBird:addReaction(arwUp)

		blinker = blinker or blink(decoyBird:getMessage(), config.timeouts.reaction, {data.user.id})

		blinker:on(arwLeft.id, function()
			page = min(pages, page + 1)

			menuSwaping()
			renderMenu()
		end)

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
	end

	renderMenu = function()
		local embed = newEmbed()

		embed:title(client.user.name)
		embed:description(parseFormat("${botDesc}", langList, client.user.name))

		embed:color(config.colors.blue)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		embed:field({
			name = format("%s %s (base)", baseEmoji.mentionString, parseFormat("${base}", langList)),
			value = parseFormat("${categoryDescBase}", langList),
			inline = true,
		})
		embed:field({
			name = format("%s %s (economy)", economyEmoji.mentionString, parseFormat("${economy}", langList)),
			value = parseFormat("${categoryDescEconomy}", langList),
			inline = true,
		})
		embed:field({
			name = format("%s %s (fun)", entertainmentEmoji.mentionString, parseFormat("${fun}", langList)),
			value = parseFormat("${categoryDescFun}", langList),
			inline = true,
		})
		embed:field({
			name = format("%s %s (moderation)", moderationEmoji.mentionString, parseFormat("${moderation}", langList)),
			value = parseFormat("${categoryDescModeration}", langList),
			inline = true,
		})

		if not decoyBird then
			decoyBird = bird:post(nil, embed:raw(), data.channel)
		else
			decoyBird:update(nil, embed:raw())
		end

		decoyBird:clearReacts()
		decoyBird:addReaction(baseEmoji)
		decoyBird:addReaction(economyEmoji)
		decoyBird:addReaction(entertainmentEmoji)
		decoyBird:addReaction(moderationEmoji)

		blinker = blinker or blink(decoyBird:getMessage(), config.timeouts.reaction, {data.user.id})

		blinker:on(baseEmoji.id,
			function()
				if not active then
					return
				else
					menuSwaping()
					renderCategory("base")
				end
			end
		)

		blinker:on(economyEmoji.id,
			function()
				if not active then
					return
				else
					menuSwaping()
					renderCategory("economy")
				end
			end
		)

		blinker:on(entertainmentEmoji.id,
			function()
				if not active then
					return
				else
					menuSwaping()
					renderCategory("fun")
				end
			end
		)

		blinker:on(moderationEmoji.id,
			function()
				if not active then
					return
				else
					menuSwaping()
					renderCategory("moderation")
				end
			end
		)

		active = true

		return true
	end

	if not value then
		renderMenu()
	end

	if command then
		if command.alias then
			value = command.origin
			command = commands.list[value]
		end

		local embed = newEmbed()

		embed:title(client.user.name)
		embed:description(parseFormat("${botDesc}", langList, client.user.name))

		embed:color(config.colors.blue)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		if command.usage ~= nil and command.usage ~= "" then
			embed:field({
				name = parseFormat("${params}", langList),
				value = format("`%s`", parseFormat(command.usage, langList)), inline = true
			})
		end

		local roleTitle = parseFormat(getMatchingLevelTitle(command.level or 0), langList)
		local levelParsed = parseFormat("${roleAndAbove}", langList, roleTitle)

		embed:field({
			name = parseFormat("${level}", langList),
			value = levelParsed, inline = true
		})

		embed:field({
			name = parseFormat("${aliases}", langList),
			value = (command.aliases and #command.aliases > 0 and concat(command.aliases, ", ") or parseFormat("${none}", langList)), inline = true
		})

		embed:color(config.colors.blue)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		bird:post(nil, embed:raw(), data.channel)

		return true
	elseif category then
		renderCategory(value)
	end
end

return {config = _config, func = _function}

--[[local _config = {
	name = "help",
	desc = "${helpMessage}",
	usage = "${pageKey}",
	aliases = {"h", "commands", "cmds"},
	cooldown = 3,
	level = 0,
	direct = true,
	perms = {"addReactions", "manageMessages"},
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local userLevel = not private and getMemberLevel(data.user, data.guild) or 0
	local value

	if args[2] then
		if type(tonumber(args[2])) == "number" then
			value = tonumber(args[2])
		elseif type(args[2]) == "string" then
			value = args[2]:lower()
		end
	else
		value = 1
	end

	if type(value) == "string" then
		local embed = newEmbed()
		local command = commands.list[value]

		if command then
			if command.alias then
				value = command.origin
				command = commands.list[value]
			end

			embed:title(format("%s", value:lower()))
			embed:description(format("%s", parseFormat(command.desc, langList)))

			if command.usage ~= nil and command.usage ~= "" then
				embed:field({
					name = parseFormat("${params}", langList),
					value = format("`%s`", parseFormat(command.usage, langList)), inline = true
				})
			end

			local roleTitle = parseFormat(getMatchingLevelTitle(command.level or 0), langList)
			local levelParsed = parseFormat("${roleAndAbove}", langList, roleTitle)

			embed:field({
				name = parseFormat("${level}", langList),
				value = levelParsed, inline = true
			})

			embed:field({
				name = parseFormat("${aliases}", langList),
				value = (command.aliases and #command.aliases > 0 and concat(command.aliases, ", ") or parseFormat("${none}", langList)), inline = true
			})

			embed:color(config.colors.blue)
			embed:footerIcon(config.images.info)
			signFooter(embed, data.author, guildLang)

			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			local text = parseFormat("${commandNotFound}", langList, value)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	elseif type(value) == "number" then
		local listTotal = 0
		local listItems = {}

		for commandName, command in pairs(commands.list) do
			if not command.alias and not isCommandRestrict(command, guildLang) then
				data.command = format("%s%s", data.prefix, command.name)

				local permit, patronCommand = canRunCommand(data)

				if permit then
					insert(listItems, {name = commandName, data = command})
					listTotal = listTotal + 1
				end
			end
		end

		sort(listItems, function(a, b)
			return a.name < b.name
		end)

		local perPage = 8
		local page = tonumber(args[2]) or 1

		local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuildId)
		local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuildId)
		local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuildId)

		local decoyBird
		local message

		local function showPage()
			local embed = newEmbed()
			local inPage = 0
			local result = ""

			embed:title(client.user.name)
			embed:description(parseFormat("${botDesc}", langList, client.user.name))

			for _, command in next, paginate(listItems, perPage, page) do
				inPage = inPage + 1

				if result ~= "" then
					result = format("%s\n", result)
				end

				if command.data.usage == "" or command.data.usage == nil then
					result = format("%s%s**%s** %s", result, topicEmoji.mentionString, command.name, parseFormat(command.data.desc, langList))
				else
					result = format("%s%s**%s** `%s` %s", result, topicEmoji.mentionString, command.name, parseFormat(command.data.usage, langList), parseFormat(command.data.desc, langList))
				end
			end

			local pages = listTotal / perPage

			if tostring(pages):match("%.%d+") then
				pages = max(1, tonumber(tostring(pages):match("%d+") + 1))
			end

			embed:field({
				name = parseFormat("${commands} (%s/%s) [${page} %s/%s]", langList, inPage, listTotal, page, pages),
				value = (result ~= "" and result or parseFormat("${noResults}", langList)), inline = true
			})

			embed:color(config.colors.blue)
			embed:footerIcon(config.images.info)
			signFooter(embed, data.author, guildLang)

			if listTotal <= perPage then
				decoyBird = decoyBird == nil and bird:post(nil, embed:raw(), data.channel)
				or decoyBird:update(nil, embed:raw())

				return true
			end

			if decoyBird == nil then
				decoyBird = bird:post(nil, embed:raw(), data.channel)
				message = decoyBird.message
				blinker = blink(message, config.timeouts.reaction, {data.user.id})

				message:addReaction(arwDown)
				message:addReaction(arwUp)

				blinker:on(arwDown.id, function()
					page = min(pages, page + 1)

					if not private then
						message:removeReaction(arwDown, data.user.id)
					end

					showPage()
				end)

				blinker:on(arwUp.id, function()
					page = max(1, page - 1)

					if not private then
						message:removeReaction(arwUp, data.user.id)
					end

					showPage()
				end)
			else
				decoyBird:update(nil, embed:raw())
			end
		end

		showPage()

		return true
	end
end

return {config = _config, func = _function}
]]
