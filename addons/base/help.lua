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
	local args = data.args

	local userLevel = not private and getMemberLevel(data.user, data.guild) or 0
	local value = args[2] and args[2]:lower()

	local command = value and inList(value, commands.list)
	local category = value and inList(value, commands.categories)

	local baseEmoji = getEmoji(config.emojis.book, "name", baseGuild)
	local economyEmoji = getEmoji(config.emojis.twoMoney, "name", baseGuild)
	local entertainmentEmoji = getEmoji(config.emojis.balloons, "name", baseGuild)
	local moderationEmoji = getEmoji(config.emojis.shield, "name", baseGuild)

	local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuild)

	local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuild)
	local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuild)
	local arwLeft = getEmoji(config.emojis.arwLeft, "name", baseGuild)
	local arwRight = getEmoji(config.emojis.arwRight, "name", baseGuild)

	local active = true
	local decoy
	local blinker

	local menuSwaping
	local renderCategory
	local renderMenu
	local counter = 0

	menuSwaping = function()
		active = false
		counter = counter + 1
		blinker:clear()

		if not private then
			decoy:clearReacts()
		end
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

		local perPage = 10
		local page = tonumber(args[2]) or 1
		local pages = listTotal / perPage
		local message

		local function showPage()
			local embed = newEmbed()
			local inPage = 0
			local result = ""

			local embed = newEmbed()

			embed:color(paint.info)
			embed:footerIcon(config.images.info)
			signFooter(embed, data.author, guildLang)

			for _, command in next, paginate(listItems, perPage, page) do
				inPage = inPage + 1

				if result ~= "" then
					result = format("%s\n", result)
				end

				if command.data.usage == "" or command.data.usage == nil then
					result = format("%s%s**%s** %s", result, topicEmoji.mentionString, command.name, localize(command.data.desc, guildLang))
				else
					result = format("%s%s**%s** `%s` %s", result, topicEmoji.mentionString, command.name, localize(command.data.usage, guildLang), localize(command.data.desc, guildLang))
				end
			end

			if tostring(pages):match("%.%d+") then
				pages = max(1, tonumber(tostring(pages):match("%d+") + 1))
			end

			embed:title(localize("${commands} (%s/%s) [${page} %s/%s]", guildLang, inPage, listTotal, page, pages))
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
			else
				decoy:update(nil, embed:raw())
			end
		end

		showPage()

		blinker = blinker or blink(decoy:getMessage(), config.timeouts.reaction, {data.user.id})

		blinker:on(arwLeft.id, function()
			page = min(pages, page + 1)

			menuSwaping()
			renderMenu()
		end)

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

		local currentCounter = counter
		local reactions = {
			[1] = arwLeft,
			[2] = arwDown,
			[3] = arwUp,
		}

		for i = 1, #reactions do
			if currentCounter ~= counter then
				break
			end

			decoy:addReaction(reactions[i])
		end
	end

	renderMenu = function()
		local embed = newEmbed()

		embed:title(client.user.name)
		embed:description(localize("${botDesc}", guildLang, client.user.name))

		embed:color(paint.info)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		embed:field({
			name = format("%s %s (base)", baseEmoji.mentionString, localize("${base}", guildLang)),
			value = localize("${categoryDescBase}", guildLang),
			inline = false,
		})
		embed:field({
			name = format("%s %s (economy)", economyEmoji.mentionString, localize("${economy}", guildLang)),
			value = localize("${categoryDescEconomy}", guildLang),
			inline = false,
		})
		embed:field({
			name = format("%s %s (fun)", entertainmentEmoji.mentionString, localize("${fun}", guildLang)),
			value = localize("${categoryDescFun}", guildLang),
			inline = false,
		})
		embed:field({
			name = format("%s %s (moderation)", moderationEmoji.mentionString, localize("${moderation}", guildLang)),
			value = localize("${categoryDescModeration}", guildLang),
			inline = false,
		})

		if not decoy then
			decoy = bird:post(nil, embed:raw(), data.channel)
		else
			decoy:update(nil, embed:raw())
		end

		if not private then
			decoy:clearReacts()
		end

		blinker = blinker or blink(decoy:getMessage(), config.timeouts.reaction, {data.user.id})

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

		local currentCounter = counter
		local reactions = {
			[1] = baseEmoji,
			[2] = economyEmoji,
			[3] = entertainmentEmoji,
			[4] = moderationEmoji,
		}

		for i = 1, #reactions do
			if currentCounter ~= counter then
				break
			end

			decoy:addReaction(reactions[i])
		end

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

		--[[embed:title(client.user.name)
		embed:description(localize("${botDesc}", guildLang, client.user.name))]]
		embed:title(format("%s", value:lower()))
		embed:description(format("%s", localize(command.desc, guildLang)))

		embed:color(paint.info)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		if command.usage ~= nil and command.usage ~= "" then
			embed:field({
				name = localize("${params}", guildLang),
				value = format("`%s`", localize(command.usage, guildLang)), inline = true
			})
		end

		local roleTitle = localize(getMatchingLevelTitle(command.level or 0), guildLang)
		local levelParsed = localize("${roleAndAbove}", guildLang, roleTitle)

		embed:field({
			name = localize("${level}", guildLang),
			value = levelParsed, inline = true
		})

		embed:field({
			name = localize("${aliases}", guildLang),
			value = (command.aliases and #command.aliases > 0 and concat(command.aliases, ", ") or localize("${none}", guildLang)), inline = true
		})

		embed:color(paint.info)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		bird:post(nil, embed:raw(), data.channel)

		return true
	elseif category then
		renderCategory(value)
	end
end

return {config = _config, func = _function}
