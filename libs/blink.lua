--[[
	Parte responsável por registrar novos direcionamentos de reações dentro das
	mensagens que forem postadas.
]]

-- Cria um construtor para registrar os métodos e metamétodos
local methods = {}
local metatable = {}

-- Registra um novo emoji e a função que deverá ser chamada quando algo for
-- filtrado de acordo com o que o construtor definiu
function methods:on(emojiId, func)
	assert(self.message, "Must create main context with constructor")

	self.active[emojiId] = func
end

-- Limpa a lista de emojis definidos para as funções
function methods:clear()
	assert(self.message, "Must create main context with constructor")

	self.active = {}
end

-- Fecha a comunicação com um dos emojis que foi definidos via on()
function methods:close()
	assert(self.message, "Must create main context with constructor")

	reactionsCallback[message.id] = {}
end

-- Retorna o vetor principal
function methods:raw()
	assert(self.message, "Must create main context with constructor")

	return self.active
end

-- Função para chamar o callback de eventos de reações nas mensagens
function metatable:__call(message, timeout, whitelist)
	assert(self.message == nil, "Context for main already exists")

	whitelist = whitelist or {}

	local result = setmetatable({
		message = message,
		timeout = timeout or config.timeouts.reaction,
		lastUse = os.time(),
		whitelist = whitelist,
		active = {},
	}, metatable)

	reactionsCallback[message.id] = result

	return result
end

-- Associa os métodos ao objeto
function metatable:__index(key)
	local method = rawget(methods, key)

	if method then
		return method
	end

	local register = rawget(reactionsCallback, key)

	if register then
		return register
	end
end

-- Registra o processo
blink = setmetatable(methods, metatable)

-- Retorna o processo para confirmar que houve a execução sem erros
return blink
