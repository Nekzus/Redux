client:on("ready", function()
	client:setGame(format("%shelp", config.default.prefix))
	print("\nFramework and modules ready")

	coroutine.wrap(function()
		print("Persistent mutes enabled")

		for k, v in next, saves.temp:get("mutes"):raw() do
			handleMuteData(v)
		end
	end)()

	coroutine.wrap(function()
		if config.saving.enabled then
			print("Auto-save routine enabled")

			while true do
				wait(config.saving.delay)

				if config.saving.enabled then
					saveAllData()
				end
			end
		else
			print("Auto-save routine disabled")
		end
	end)()

	coroutine.wrap(function()
		if config.clean.enabled then
			print("Cleanser routine enabled")

			while true do
				wait(config.clean.delay)

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
	end)()
end)
