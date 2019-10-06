-- VOICE LOAD https://github.com/rokf/nandek/blob/master/bot.lua
-- https://github.com/fabiocolacio/discord-sound-board/blob/master/discord_sound_board.lua
-- https://en.wikipedia.org/wiki/Names_of_large_numbers
-- https://github.com/kekkus-vult/garbage-person-v2/blob/master/commands/urban.lua

client:on("messageCreate",
	function(message)
		if message.author == client.user then
			return
		end

		if message.author.bot then
			return
		end

		if baseGuild == nil then
			baseGuild = client:getGuild(config.meta.baseGuild)
			timer.sleep(1000)
		end

		local data = {
			message = message,
			content = message.content,
			user = message.member or message.author,
			author = message.author,
			member = message.member,
			channel = message.channel,
			guild = message.guild,
			args = message.content:split(" "),
			command = message.content:split(" ")[1],
		}

		local private = data.member == nil
		local guildData = not private and getGuildData(data.guild)
		local guildLang = not private and guildData and guildData:get("lang") or config.default.lang
		local langList = langs[guildLang]
		local deleteCommand = not private and guildData:get("deleteCommand", false) or false

		if not private then
			data.guildData = guildData
			data.guildLang = guildLang
			data.prefix = guildData:raw().prefix
		else
			data.guildLang = config.default.lang
			data.prefix = config.default.prefix
		end

		local commandPrefix = data.prefix
		local commandName = data.command:lower():sub(#commandPrefix + 1)
		local commandData = commandName and commands.list[commandName]
		local commandCategory = commandData and commandData.category:match("%w+")

		if commandData and (data.command:lower() == format("%s%s", commandPrefix, commandName:lower())) then
			local userData = saves.temp:get(format("users/%s", data.user.id))
			local commandPermit, commandPatron = canRunCommand(data)

			if not bot.loaded then
				data.channel:reply("Bot is restarting, please try again in a few seconds..")

				return false
			end

			if not commandPermit then
				if commandPatron then
					local text = parseFormat("${noPerm}; ${patronsOnlyCommand}", langList)
					local embed = replyEmbed(text, message, "error")

					bird:post(nil, embed:raw(), data.channel)
				else
					local text = parseFormat("${noPerm}", langList)
					local embed = replyEmbed(text, message, "error")
					bird:post(nil, embed:raw(), data.channel)
				end

				if deleteCommand == true then
					message:delete()
				end

				return false

			elseif isCommandRestrict(commandData, guildLang) then
				local text = parseFormat("${notAvailableLang}", langList)
				local embed = replyEmbed(text, message, "warn")

				return bird:post(nil, embed:raw(), data.channel)
			end

			if private and not commandData.allowDm then
				if deleteCommand == true then
					message:delete()
				end

				local text = parseFormat("${executeFromGuild}", langList)
				local embed = replyEmbed(text, message, "error")

				return bird:post(nil, embed:raw(), data.channel)
			end

			if commandCategory then
				if commandCategory == "economy" then
					if config.economyDefault.actions[commandName] then
						local canUse, timeLeft = canUseEconomyCommand(commandName, data.user, data.guild)

						if not canUse then
							local text = parseFormat("${commandCooldownFor}", langList, timeLeft)
							local embed = replyEmbed(text, data.message, "warn")

							return bird:post(nil, embed:raw(), data.channel)
						end
					end
				else
					local canUse, timeLeft = canUseCommand(commandName, data.author)

					if canUse then
						updateCommandCooldown(commandName, data.user)
					else
						local text = parseFormat("${commandCooldownFor}", langList, timeLeft)
						local embed = replyEmbed(text, data.message, "warn")

						return bird:post(nil, embed:raw(), data.channel)
					end
				end
			end

			local success, commandError = pcall(commandData.func, data)
			deleteCommand = not private and guildData:get("deleteCommand", false) or false

			if not success then
				printf("\nCommand Error: '%s' | %s\nInformation: '%s' | %s", commandName, commandError, data.author.tag, data.message.content)
			end

			if not private then
				deleteCommand = guildData:get("deleteCommand", false)

				if deleteCommand == true then
					message:delete()
				end
			end
		end
	end
)
