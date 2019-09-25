local _config = {
	name = "help",
	desc = "${helpMessage}",
	usage = "${pageKey}",
	aliases = {"h", "commands", "cmds", "cmd"},
	cooldown = 3,
	level = 0,
	direct = true,
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
				embed:field({name = parseFormat("${params}", langList), value = format("`%s`", parseFormat(command.usage, langList)), inline = true})
			end

			local roleTitle = parseFormat(getMatchingLevelTitle(command.level or 0), langList)
			local levelParsed = parseFormat("${roleAndAbove}", langList, roleTitle)

			embed:field({name = parseFormat("${level}", langList), value = levelParsed, inline = true})
			embed:field({name = parseFormat("${aliases}", langList), value = (command.aliases and #command.aliases > 0 and concat(command.aliases, ", ") or parseFormat("${none}", langList)), inline = true})

			embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
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
		local nCount = 0
		local rList = {}

		for commandName, command in pairs(commands.list) do
			if not command.alias and not isCommandRestrict(command, guildLang) then
				data.command = format("%s%s", data.prefix, command.name)

				local permit, patronCommand = canRunCommand(data)

				if permit then
					insert(rList, {name = commandName, data = command})
					nCount = nCount + 1
				end
			end
		end

		sort(rList, function(a, b)
			return a.name < b.name
		end)

		local perPage = 10
		local page = tonumber(args[2]) or 1

		local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuild)
		local arwLeft = getEmoji(config.emojis.arwLeft, "name", baseGuild)
		local arwRight = getEmoji(config.emojis.arwRight, "name", baseGuild)

		local decoyBird
		local message

		local function showPage()
			local embed = newEmbed()
			local count = 0
			local result = ""

			embed:title(client.user.name)
			embed:description(parseFormat("${botDesc}", langList, client.user.name))

			for _, command in next, paginate(rList, perPage, page) do
				count = count + 1

				if result ~= "" then
					result = format("%s\n", result)
				end

				if command.data.usage == "" or command.data.usage == nil then
					result = format("%s%s**%s** %s", result, topicEmoji.mentionString, command.name, parseFormat(command.data.desc, langList))
				else
					result = format("%s%s**%s** `%s` %s", result, topicEmoji.mentionString, command.name, parseFormat(command.data.usage, langList), parseFormat(command.data.desc, langList))
				end
			end

			local pages = nCount / perPage

			if tostring(pages):match("%.%d+") then
				pages = max(1, tonumber(tostring(pages):match("%d+") + 1))
			end

			embed:field({name = parseFormat("${commands} (%s/%s) [${page} %s/%s]", langList, count, nCount, page, pages), value = (result ~= "" and result or parseFormat("${noResults}", langList)), inline = true})

			embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
			embed:footerIcon(config.images.info)
			signFooter(embed, data.author, guildLang)

			if nCount <= perPage then
				decoyBird = decoyBird == nil and bird:post(nil, embed:raw(), data.channel)
				or decoyBird:update(nil, embed:raw())

				return true
			end

			if decoyBird == nil then
				decoyBird = bird:post(nil, embed:raw(), data.channel)
				message = decoyBird.message
				blinker = blink(message, config.meta.reactionTimeout, {data.user.id})

				message:addReaction(arwLeft)
				message:addReaction(arwRight)

				blinker:on(arwLeft.id, function()
					page = max(1, page - 1)
					message:removeReaction(arwLeft, data.user.id)
					showPage()
				end)

				blinker:on(arwRight.id, function()
					page = min(pages, page + 1)
					message:removeReaction(arwRight, data.user.id)
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
