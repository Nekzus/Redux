client:on("ready",
	function()
		client:setGame({
			type = 2,
			name = join(config.templates.guild.prefix, "help")
		})

		coroutine.wrap(
			function()
				for guid,_ in next, saves.temp:get("mutes"):raw() do
					resumeMute(guid)
				end

				client:info("Resumed previous mutes")
			end
		)()

		client:info("Framework and modules ready")
	end
)
