--[[
	Parte responsável por registrar novos direcionamentos de reações dentro das
	mensagens que forem postadas.
]]

-- Cria um construtor para registrar os métodos e metamétodos
local main = {}
main.__index = main

-- Função para chamar o callback de eventos de reações nas mensagens
function main:__call(message, timeout, whitelist)
	assert(self.message == nil, "Context for main already exists")

	whitelist = whitelist or {}

	local mt = setmetatable({
		message = message,
		timeout = timeout or config.timeouts.reaction,
		lastUse = os.time(),
		whitelist = whitelist,
		active = {},
	}, main)

	reactionsCallback[message.id] = mt

	return mt
end

-- Registra um novo emoji e a função que deverá ser chamada quando algo for
-- filtrado de acordo com o que o construtor definiu
function main:on(emojiId, func)
	assert(self.message, "Must create main context with constructor")
	self.active[emojiId] = func
end

-- Limpa a lista de emojis definidos para as funções
function main:clear()
	assert(self.message, "Must create main context with constructor")
	self.active = {}
end

-- Fecha a comunicação com um dos emojis que foi definidos via on()
function main:close()
	assert(self.message, "Must create main context with constructor")
	reactionsCallback[message.id] = {}
end

-- Retorna o vetor principal
function main:raw()
	assert(self.message, "Must create main context with constructor")
	return self.active
end

-- Registra o processo
blink = setmetatable({}, main)

-- Retorna o processo para confirmar que houve a execução sem erros
return blink
