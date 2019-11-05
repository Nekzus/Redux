--[[
	Parte responsável por administrar reações sendo adicionadas ou clicadas
	em uma mensagem. Esse evento irá redirecionar as informações necessárias
	conforme o que for registrado na table reactionsCallback
]]

client:on("reactionAdd",
	function(reaction, userId)
		-- Registra ou retorna a table responsável por segurar as informações
		-- das reações e permissões
		reactionsCallback = reactionsCallback or {}

		-- Pega as informações mais importantes
		local message = reaction.message
		local blinkData = message and reactionsCallback[message.id]

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
