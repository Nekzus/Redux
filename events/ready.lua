client:on("ready",
	function()
		client:setGame({
			type = 2,
			name = join(config.defaultGuild.prefix, "help")
		})

		client:info("Framework and modules ready")

		coroutine.wrap(
			function()
				client:info("Persistent mutes enabled")

				for guid,_ in next, saves.temp:get("mutes"):raw() do
					resumeMute(guid)
				end
			end
		)()

		coroutine.wrap(
			function()
				if config.cleaner.enabled then
					client:info("Cleanser routine enabled")

					reactionsData = reactionsData or {}

					while wait(config.cleaner.delay) do
						for messageId, blinkData in next, reactionsData do
							local timeout = blinkData.timeout
							local tick = blinkData.tick
							local now = os.time()

							if (now - tick) > timeout then
								reactionsData[messageId] = nil
							end
						end
					end
				else
					client:warning("Cleanser routine disabled")
				end
			end
		)()
	end
)
