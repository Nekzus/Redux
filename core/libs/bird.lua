-- Cria um construtor para registrar os métodos e metamétodos
local main = {}
main.__index = main

-- Função para postar mensagens, age como um construtor que retorna métodos que podem ser utilizados
function main:post(text, embed, channel)
	local reply = {}

	if text then
		assert(type(text) == "string", "Text must be a string")
		reply.content = text
	end

	if embed then
		assert(type(embed) == "table", "Embed must be a table")
		reply.embed = embed
	end

	return setmetatable({
		message = channel:send(reply)
	}, main)
end

-- Retorna o objeto da mensagem que foi registrada ao chamar o método construtor
function main:getMessage()
	assert(self.message, "Must create main context with :post() first")
	return self.message
end

-- Atualiza os itens do conteúdo do objeto que foram postados
function main:update(content, embed)
	assert(self.message, "Must create main context with :post() first")

	if content ~= true then
		self.message:setContent(content)
	end

	if embed ~= true then
		self.message:setEmbed(embed)
	end
end

-- Deleta o conteúdo do objeto
function main:delete()
	assert(self.message, "Must create main context with :post() first")
	return self.message:delete()
end

-- Adiciona uma reação ao conteúdo do objeto
function main:react(emoji)
	assert(self.message, "Must create main context with :post() first")
	return self.message:addReaction(emoji)
end

-- Remove uma reação do conteúdo do objeto
function main:removeReact(emoji, userId)
	assert(self.message, "Must create main context with :post() first")
	return self.message:removeReaction(emoji, userId)
end

-- Limpa todas as reações que foram adicionadas ao conteúdo do objeto
function main:clearReacts()
	assert(self.message, "Must create main context with :post() first")
	return self.message:clearReactions()
end

-- Fixa a mensagem no canal em que o conteúdo do objeto foi postado
function main:pin()
	assert(self.message, "Must create main context with :post() first")

	local message = self.message
	local channel = message.channel
	local pinned = channel:getPinnedMessages():toArray()

	if #pinned >= 50 then
		pinned[#pinned]:unpin()
	end

	return message:pin()
end

-- Remove a mensagem das mensagens fixas no canal que o conteúdo do objeto foi postado
function main:unpin()
	assert(self.message, "Must create main context with :post() first")

	local message = self.message

	if message.pinned then
		message:unpin()
	end

	return true
end

-- Registra o processo
bird = main

-- Retorna o processo para confirmar que houve a execução sem erros
return bird
