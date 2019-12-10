client:on("ready",
	function()
		client:setGame({
			type = 2,
			name = format("%shelp", config.defaultGuild.prefix)
		})

		print("\n")
		print("Framework and modules ready")

		coroutine.wrap(
			function()
				print("Persistent mutes enabled")

				for _, muteData in next, saves.temp:get("mutes"):raw() do
					handleMuteData(muteData)
				end
			end
		)()

		coroutine.wrap(
			function()
				if config.cleaner.enabled then
					print("Cleanser routine enabled")

					reactionsData = reactionsData or {}

					while wait(config.cleaner.delay) do
						for messageId, blinkData in next, reactionsData do
							local timeout = blinkData.timeout
							local lastUse = blinkData.lastUse
							local now = os.time()

							if (now - lastUse) > timeout then
								reactionsData[messageId] = nil
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
