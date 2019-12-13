client:on("reactionAdd",
	function(reaction, userId)
		local message = reaction.message
		local blinkList = blink:raw()
		local blinkData = blinkList and blinkList[message.id]

		if not blinkData then
			return
		elseif not inList(userId, blinkData.whitelist) then
			return
		end

		for emojiId, callback in next, blinkData.active do
			if emojiId == reaction.emojiId then
				local lifetime = blinkData.lifetime
				local tick = blinkData.tick
				local now = os.time()

				if (now - tick) <= lifetime then
					blinkData.tick = os.time()
					callback(userId)
				else
					blinkList[message.id] = nil
				end
			end
		end
	end
)
