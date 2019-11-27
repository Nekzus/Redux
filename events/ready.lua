--[[
	Parte responsável por iniciar tarefas específicas do bot para o Discord
	assim que for retornada uma resposta positiva por parte da API de conexão
	aos servidores
]]

client:on("ready",
	function()
		-- Define o status do bot, assim facilitando para pessoas saberem
		-- como utilizá-lo
		client:setGame {
			type = 2,
			name = format("%shelp", config.defaultGuild.prefix)
		}

		-- Inicio do log de report para o console
		print("\n")
		print("Framework and modules ready")

		-- Re-inicializa todas as contagens de mutes que foram feitas desde
		-- a última vez que o bot foi utilizado, assim, garantindo a persistência
		-- para os mutes temporizados
		coroutine.wrap(
			function()
				print("Persistent mutes enabled")

				local temp = getTempData()
				temp:open()

				for _, muteData in next, temp:get("mutes"):raw() do
					handleMuteData(muteData)
				end

				temp:close()
			end
		)()

		-- Inicializa o processo de saving das informações armazenadas pelo bot
		-- assim, garantindo que todos os dados de guildas e usuários sejam
		-- persistentes
		coroutine.wrap(
			function()
				if config.saver.enabled then
					print("Auto-save routine enabled")

					while true do
						wait(config.saver.delay)

						if config.saver.enabled then
							saveAllData()
						end
					end
				else
					print("Auto-save routine disabled")
				end
			end
		)()

		-- Inicializa uma rotina de limpeza à dados utilizados pelo bot, pois
		-- de outra forma, o bot eventualmente armazenaria muito "lixo" de
		-- usuários inativos e comandos
		coroutine.wrap(
			function()
				if config.cleaner.enabled then
					print("Cleanser routine enabled")

					reactionsCallback = reactionsCallback or {}

					while true do
						wait(config.cleaner.delay)

						for messageId, blinkData in next, reactionsCallback do
							local timeout = blinkData.timeout
							local lastUse = blinkData.lastUse
							local now = os.time()

							if (now - lastUse) > timeout then
								reactionsCallback[messageId] = nil
							end
						end
					end
				else
					print("Cleanser routine disabled")
				end
			end
		)()

		print("\n")
	end
)
