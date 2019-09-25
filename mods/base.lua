commands:create({name = "",
	desc = "",
	usage = "",
	level = 5,

	func = 
}):accept("unpat", "rpat", "unpremium", "unvip")

commands:create({name = "reload",
	desc = "${reloadsBotModules}",
	usage = "",
	level = 5,
	allowDm = true,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local decoy = bird:post(getLoadingEmoji(), nil, data.channel)

		saveAllData()

		coroutine.wrap(function()
			commands:flushList()
			loadBot()
		end)()

		local text = parseFormat("${botModulesReloaded}", langList)
		local embed = replyEmbed(text, data.message, "ok")

		decoy:update(nil, embed:raw())

		return true
	end
}):accept("rel", "boot", "reboot", "restart")

commands:create({name = "lua",
	desc = "${allowsLua}",
	usage = "${codeKey}",
	level = 5,
	allowDm = true,

	func = function(data)
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

		local decoy = bird:post(getLoadingEmoji(), nil, data.channel)
		local success, response = loadCode(data.content:sub(#args[1] + 2), data.message, {os = os, data = data})

		local embed = replyEmbed(response, data.message, (success and "ok" or "error"))

		decoy:update(nil, embed:raw())

		return true
	end
}):accept("run", "f", "code")

commands:create({name = "ping",
	desc = "${saysPong}",
	usage = "",
	cd = 5,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local text = parseFormat("${pong}!", langList)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	end
}):accept("p")

commands:create({name = "quote",
	desc = "${quotesMesage}",
	usage = "${messageKey}",
	cd = 3,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		if not args[2] then
			return replyEmbed(parseFormat("${missingArg}", langList), data.message, "error")
		end

		local decoy = bird:post(getLoadingEmoji(), nil, data.channel)
		local tries = 10
		local terms = data.content:sub(#args[1] + 2)
		local isNum = tonumber(terms)
		local targetMessage

		if isNum and #terms == 18 then
			targetMessage = data.channel:getMessage(terms)
		else
			local lastMessage = data.message
			local lastChecked

			for i = 1, tries do
				if not lastMessage or lastChecked == lastMessage then
					break
				end

				lastChecked = lastMessage
				local messagesCache = data.channel:getMessagesBefore(lastMessage.id, 100)
				local ret = {}

				for message in messagesCache:iter() do
					lastMessage = message

					if message.content:lower():match(terms) then
						ret[#ret + 1] = message
					end
				end

				if #ret > 0 then
					sort(ret, function(a, b)
						return a.createdAt < b.createdAt
					end)

					targetMessage = ret[#ret]

					break
				end
			end
		end

		if targetMessage then
			local jumpTo = parseFormat("[${jumpToMessage}](%s)", langList, targetMessage.link)
			local sentBy = parseFormat("${messageSentBy}", langs[guildLang], targetMessage.author.tag)
			local embed = newEmbed()

			embed:author(sentBy)
			embed:authorImage(targetMessage.author.avatarURL)
			embed:description(format("%s\n\n%s", targetMessage.content, jumpTo))
			embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
			embed:footerIcon(config.images.info)
			signFooter(embed, data.author, guildLang)

			decoy:update(nil, embed:raw())

			return true
		else
			local text = parseFormat("${messageWithTermsNotFound}", langList, terms)
			local embed = replyEmbed(text, data.message, "warn")

			decoy:update(nil, embed:raw())

			return false
		end
	end
}):accept("q")

commands:create({name = "invite",
	desc = "${invitesNekito}",
	usage = "",
	level = 5,
	allowDm = true,

	func = function(data) -- https://discordapp.com/api/oauth2/authorize?client_id=309586161876205579&permissions=8&scope=bot
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local text = parseFormat("${neksInvite}", langList, config.meta.invite)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	end
}):accept("inv")
