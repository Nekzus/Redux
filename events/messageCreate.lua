-- VOICE LOAD https://github.com/rokf/nandek/blob/master/bot.lua
-- https://github.com/fabiocolacio/discord-sound-board/blob/master/discord_sound_board.lua
-- https://en.wikipedia.org/wiki/Names_of_large_numbers
-- https://github.com/kekkus-vult/garbage-person-v2/blob/master/commands/urban.lua
-- https://github.com/sillsdog/azerty-lua/blob/master/commands.lua

client:on("messageCreate",
	function(message)
		-- Ignorar quando o próprio bot enviar uma mensagem
		if message.author == client.user then
			return
			-- Ignorar quando outro bot também estiver enviando mensagens
		elseif message.author.bot then
			return
		end

		-- Coleta os recursos da guilda base
		if baseGuild == nil then
			baseGuild = client:getGuild(config.main.baseGuildId)
			timer.sleep(1000)
		end

		-- Cria um pacote de informações relevantes para serem
		-- enviados à função específica do comando
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

		-- Coleta informações relevantes da guilda
		local private = data.member == nil
		local guildData = not private and getGuildData(data.guild)
<<<<<<< Updated upstream
		local guildMutes = guildData:get("mutes")
		local guildLang = not private and guildData and guildData:get("lang") or config.defaultGuild.lang
		local muteData = not private and guildMutes:raw()[data.member.id]
		local langData = langs[guildLang]
=======
		local guildMutes = guildData and guildData:get("mutes")
		local guildLang = guildData and guildData:get("lang") or config.defaultGuild.lang
		local muteData = guildMutes and guildMutes:raw()[data.member.id]
>>>>>>> Stashed changes
		local botMember = not private and data.guild:getMember(client.user.id)

		-- Verifica se o usuário está mutado
		if muteData then
			-- Coleta os dados do cargo de mute, caso houver
			local roleId = getPrimaryRoleIndex(-1, guildData:get("roles"):raw())
			local role = roleId and getRole(roleId, "id", data.guild)

			-- Havendo o cargo, parte para verificar se o membro já tem o cargo
			-- e caso a verificação for negativa, checa as permissões e por
			-- fim atribui o cargo e deleta a mensagem do usuário
			if role and not data.member:hasRole(role) then
				-- Valida se o bot tem permissão de atribuir cargos
				if hasPermissions(data.member, nil, {"manageRoles"}) then
					data.member:addRole(role)
				end

				-- Valida se o bot tem permissão de deletar mensagens
				if hasPermissions(data.member, nil, {"manageMessages"}) then
					data.message:delete()
				end

				return false
			end
		end

		-- Caso o bot estiver agindo em um canal privado (mensagens diretas)
		if private then
			data.guildLang = config.defaultGuild.lang
			data.prefix = config.defaultGuild.prefix
		else
			-- Caso estiver agindo no canal de uma guilda
			data.guildData = guildData
			data.guildLang = guildLang
			data.prefix = guildData:raw().prefix
		end

		-- Coleta as informações mais relevantes do comando sendo executado
		local commandPrefix = data.prefix
		local commandName = data.command:lower():sub(#commandPrefix + 1)
		local commandData = commandName and commands.list[commandName]
		local commandCategory = commandData and commandData.category:match("%w+")
		local commandDataPerms = commandData and commandData.perms

		-- Checa se o comando bate com o que registramos e com o prefixo passado
		if commandData and (data.command:lower() == format("%s%s", commandPrefix, commandName:lower())) then
			local temp = getTempData()
			local userData = temp:get(format("users/%s", data.user.id))
			local commandPermit, commandPatron = canRunCommand(data)

			-- Caso o bot estiver em processo de reinicialização
			-- notifica o usuário para tentar novamente em alguns segundos
			if not bot.loaded then
				data.channel:reply("Bot is restarting, please try again in a few seconds..")
				return false
			end

			-- Verifica se o usuário pode executar o comando
			if not commandPermit then
				-- Informa caso o comando for reservado apenas para patronos
				if commandPatron then
					local text = parseFormat("${noPerm}; ${patronsOnlyCommand}", langData)
					local embed = replyEmbed(text, message, "error")

					bird:post(nil, embed:raw(), data.channel)
					-- Informe caso por algum outro motivo o usuário não tiver permissão
				else
					local text = parseFormat("${noPerm}", langData)
					local embed = replyEmbed(text, message, "error")

					bird:post(nil, embed:raw(), data.channel)
				end

				return false
				-- Valida se o comando está reestrito apenas para guildas definidas
			elseif isCommandRestrict(commandData, guildLang) then
				local text = parseFormat("${notAvailableLang}", langData)
				local embed = replyEmbed(text, message, "warn")

				return bird:post(nil, embed:raw(), data.channel)
			end

			-- Valida se o comando só pode ser executado em mensagens privadas
			if private and not commandData.direct then
				local text = parseFormat("${executeFromGuild}", langData)
				local embed = replyEmbed(text, message, "error")

				return bird:post(nil, embed:raw(), data.channel)
			end

			-- Caso o comando não for privado, aplica as validações necessárias
			-- verificando se o bot tem permissões essenciais que são comuns
			-- entre todos os comandos do bot
			if not private then
				-- Cria a lista de permissões essenciais
				local permsList = {
					"embedLinks",
					"sendMessages",
					"useExternalEmojis",
					"addReactions",
				}

				-- Caso houverem permissões específicas necessárias para o
				-- comando sendo executado, atribui à lista de checagem
				if commandDataPerms then
					for _, perm in next, commandData.perms do
						insert(permsList, perm)
					end
				end

				-- Valida se o bot tem as permissões passadas na função de
				-- checagem, caso não, retorna quais permissões estão faltando
				-- em formato adaptado para tradução do sistema do bot
				local hasPerms, permsData = hasPermissions(botMember, data.channel, permsList)

				-- Se o bot não tiver permissões, retorna quais estão faltando
				-- em formato adaptado e traduzido para a guilda atual
				if not hasPerms then
					local formatted = parseFormat(format("**%s**", permsData.text), langData):lower()
					local text = parseFormat("${missingThesePerms}", langData, formatted)

					if inList("embedLinks", permsData.list) then
						return bird:post(text, nil, data.channel)
					else
						local embed = replyEmbed(text, data.message, "warn")

						return bird:post(nil, embed:raw(), data.channel)
					end
				end
			end

			-- Caso existir uma categoria para o comando mencionado, verifica
			-- em qual ela se enquadra para tratar cada caso conforme necessário
			if commandCategory then
				-- Caso o comando for classificado como economia, aplica os tempos
				-- de cooldown conforme o que foi definido pelos administradores
				-- da guilda atual
				if commandCategory == "economy" then
					if config.defaultEconomy.actions[commandName] then
						local canUse, timeLeft = canUseEconomyCommand(commandName, data.user, data.guild)

						if not canUse then
							local text = parseFormat("${commandCooldownFor}", langData, timeLeft)
							local embed = replyEmbed(text, data.message, "warn")

							return bird:post(nil, embed:raw(), data.channel)
						end
					end
				else
					-- De outra forma, aplica os cooldowns padrões de cada comando
					local canUse, timeLeft = canUseCommand(commandName, data.author)

					if canUse then
						updateCommandCooldown(commandName, data.user)
					else
						local text = parseFormat("${commandCooldownFor}", langData, timeLeft)
						local embed = replyEmbed(text, data.message, "warn")

						return bird:post(nil, embed:raw(), data.channel)
					end
				end
			end

			-- Por fim, executa o comando com suporte à erro para garantir que
			-- não ocorram problemas com a thread principal, e caso ocorrer,
			-- retorna um log detalhado no console para análise e tratativa
			local success, commandError = pcall(commandData.func, data)
			guildData:close()

			-- Cria o relatório de erro
			if not success then
				printf(
					"\nCommand Error: %s | %s\nInformation: %s | %s\nError Stack: %s",
					commandName, -- Retorna o nome do comando
					commandError, -- Retorna o erro que deu no comando
					data.author.tag, -- Retorna o usuário que executou
					data.message.content, -- Os argumentos utilizados
					debug.traceback() -- Um log de onde ocorreu o erro
				)
			end
		end
	end
)
