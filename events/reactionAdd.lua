client:on("reactionAdd",
	function(reaction, userId)
		local message = reaction.message
		local blinkData = message and reactionsCallback[message.id]

		reactionsCallback = reactionsCallback or {}

		if not blinkData then
			return
		end

		local active = blinkData and blinkData:raw()

		if not active then
			return
		end

		if not inList(userId, blinkData.whitelist) then
			return
		end

		for id, func in next, active do
			if id == reaction.emojiId then
				local timeout = blinkData.timeout
				local lastUse = blinkData.lastUse
				local now = os.time()

				if (now - lastUse) <= timeout then
					blinkData.lastUse = os.time()
					func(userId)
				else
					reactionsCallback[message.id] = {}
				end
			end
		end
	end
)
