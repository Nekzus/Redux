client:on("reactionAdd",
	function(reaction, userId)
		reactionsData = reactionsData or {}

		local message = reaction.message
		local blinkData = message and reactionsData[message.id]
		local active = blinkData and blinkData:raw()

		if not active then
			return
		elseif not inList(userId, blinkData.whitelist) then
			return
		end

		for emojiId, callback in next, active do
			if emojiId == reaction.emojiId then
				local timeout = blinkData.timeout
				local lastUse = blinkData.lastUse
				local now = os.time()

				if (now - lastUse) <= timeout then
					blinkData.lastUse = os.time()
					callback(userId)
				else
					reactionsData[message.id] = {}
				end
			end
		end
	end
)
