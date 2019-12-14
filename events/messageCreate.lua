client:on("messageCreate",
	function(message)
		if message.author == client.user
		--or message.author.bot
		or not bot.loaded then
			return
		end

		if baseGuild == nil then
			baseGuild = client:getGuild(config.main.guilds.home.id)
			wait(1)
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
		local guildMutes = not private and guildData:get("mutes")
		local guildLang = not private and guildData and guildData:get("lang") or config.defaultGuild.lang
		local muteData = not private and guildMutes:raw()[data.member.id]
		local botMember = not private and data.guild:getMember(client.user.id)

		if private then
			data.guildLang = config.defaultGuild.lang
			data.prefix = config.defaultGuild.prefix
		else
			data.guildData = guildData
			data.guildLang = guildLang
			data.prefix = guildData:raw().prefix

			if muteData then
				local roleId = getPrimaryRoleIndex(-1, guildData:get("roles"):raw())
				local role = roleId and getRole(roleId, "id", data.guild)

				if role and not data.member:hasRole(role) then
					if hasPermissions(botMember, nil, {"manageRoles"}) then
						data.member:addRole(role)
					end

					if hasPermissions(botMember, nil, {"manageMessages"}) then
						data.message:delete()
					end

					return false
				end
			end

			if not data.args[2] then
				if data.message.mentionedUsers.first == client.user then
					bird:post(localize("${guildPrefix}", guildLang, data.prefix), nil, data.channel)
					return true
				end
			end

			local memberRoles = getUserDefinedRoles(data.member, data.guild)

			if #memberRoles == 0 then
				local memberRoleId = getPrimaryRoleIndex(0, guildData:get("roles"):raw())
				local memberRole = memberRoleId and getRole(memberRoleId, "id", guild)

				if memberRole then
					member:addRole(memberRole)
				end
			end
		end

		local commandPrefix = data.prefix
		local commandName = data.command:lower():sub(#commandPrefix + 1)
		local commandData = commandName and worker:getCommand(commandName)
		local commandCategory = commandData and commandData.category:match("%w+")
		local commandDataPerms = commandData and commandData.perms

		if commandData and join(commandPrefix, commandName:lower()) == data.command then
			local userData = saves.temp:get(string.format("users/%s", data.user.id))
			local commandPermit, commandPatron = canRunCommand(data)

			if not commandPermit then
				if commandPatron then
					local text = localize("${noPerm}; ${patronsOnlyCommand}", guildLang)
					local embed = replyEmbed(text, message, "error")

					bird:post(nil, embed:raw(), data.channel)
				else
					local text = localize("${noPerm}", guildLang)
					local embed = replyEmbed(text, message, "error")

					bird:post(nil, embed:raw(), data.channel)
				end

				return false
			elseif isCommandRestrict(commandData, guildLang) then
				local text = localize("${notAvailableLang}", guildLang)
				local embed = replyEmbed(text, message, "warn")

				return bird:post(nil, embed:raw(), data.channel)
			end

			if private and not commandData.direct then
				local text = localize("${executeFromGuild}", guildLang)
				local embed = replyEmbed(text, message, "error")

				return bird:post(nil, embed:raw(), data.channel)
			end

			if not private then
				local permsList = {
					"embedLinks",
					"sendMessages",
					"useExternalEmojis",
					"addReactions",
				}

				if commandDataPerms then
					for _, perm in next, commandData.perms do
						table.insert(permsList, perm)
					end
				end

				local hasPerms, permsData = hasPermissions(botMember, data.channel, permsList)

				if not hasPerms then
					local formatted = localize(string.format("**%s**", permsData.text), guildLang):lower()
					local text = localize("${missingThesePerms}", guildLang, formatted)

					if inList("embedLinks", permsData.list) then
						return bird:post(text, nil, data.channel)
					else
						local embed = replyEmbed(text, data.message, "warn")

						return bird:post(nil, embed:raw(), data.channel)
					end
				end
			end

			if commandCategory then
				if commandCategory == "economy" then
					if config.defaultEconomy.actions[commandName] then
						local canUse, timeLeft = canUseEconomyCommand(commandName, data.user, data.guild)

						if timeLeft then
							timeLeft = localize(timeLong(timeLeft), guildLang)
						end

						if not canUse then
							local text = localize("${commandCooldownFor}", guildLang, timeLeft)
							local embed = replyEmbed(text, data.message, "warn")

							return bird:post(nil, embed:raw(), data.channel)
						end
					end
				else
					local canUse, timeLeft = canUseCommand(commandName, data.author)

					if timeLeft then
						timeLeft = localize(timeLong(timeLeft), guildLang)
					end

					if canUse then
						updateCommandCooldown(commandName, data.user)
					else
						local text = localize("${commandCooldownFor}", guildLang, timeLeft)
						local embed = replyEmbed(text, data.message, "warn")

						return bird:post(nil, embed:raw(), data.channel)
					end
				end
			end

			data.channel:broadcastTyping()

			local success, commandError = pcall(commandData.func, data)

			if not success then
				local embed = newEmbed()

				embed:title(localize("${scriptErrorFor}", guildLang, commandName))
				embed:description(commandError)
				signFooter(embed, data.author, guildLang)
				embed:color(paint.error)
				embed:footerIcon(config.images.error)

				bird:post(nil, embed:raw(), data.channel)

				printf(
					"\nCommand Error: %s | %s\nInformation: %s",
					commandName,
					commandError,
					data.author.tag,
					data.message.content
				)
			end
		end
	end
)
