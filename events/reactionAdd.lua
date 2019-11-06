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

		-- Pega as informações mais importantes referentes aos objetos
		-- relacionados à reação que foi clicada
		local message = reaction.message
		local blinkData = message and reactionsCallback[message.id]
		local active = blinkData and blinkData:raw()

		-- Verifica a atividade da mensagem dentre os callbacks e relaciona
		-- com a lista de permissões para ver se o usuário que clicou na
		-- reação pode dar inicio em uma função registrada de callback
		if not active then
			return
		elseif not inList(userId, blinkData.whitelist) then
			return
		end

		-- Verifica entre os callbacks registrados qual emoji para as reações
		-- tem um callback, assim o executando e atualizando a última vez que
		-- a função que engloba as reações da mensagem foi utilizada
		for emojiId, callback in next, active do
			if emojiId == reaction.emojiId then
				local timeout = blinkData.timeout
				local lastUse = blinkData.lastUse
				local now = os.time()

				if (now - lastUse) <= timeout then
					blinkData.lastUse = os.time()
					callback(userId)
				else
					reactionsCallback[message.id] = {}
				end
			end
		end
	end
)
