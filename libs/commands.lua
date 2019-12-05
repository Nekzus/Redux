--[[
	Parte responsável por registrar comandos e aliases para eles.
]]

-- Cria um construtor para registrar os métodos e metamétodos
local methods = {}
local metatable = {}
local pool = {
	list = {},
	aliases = {},
	categories = {}
}

function methods:create(data)
	data = data or {}

	local name = assert(data.name, "Missing name for command on create")
	local category = assert(data.category, "Missing category for command")
	category = category and category:match("%w+")

	if category and not inList(category, pool.categories) then
		insert(pool.categories, category)
	end

	pool.list[name] = data

	return setmetatable(data, metatable)
end

function methods:accept(...)
	assert(self.name, "Must create command first")

	local list = {...}

	assert(#list > 0, "Must provide an alias")

	for _, alias in next, list do
		local exists = pool.aliases[alias]

		if exists then
			printf("Alias %s already exists for command %s", alias, exists.name)
			return false
		end

		pool.aliases[alias] = self.name
	end
end

function methods:getCommand(name)
	local command = pool.list[name]
	local aliases = pool.aliases[name]

	return command or (aliases and pool.list[aliases])
end

-- Limpa a lista de comandos completamente
function methods:flushList()
	for list, _ in next, pool do
		pool[list] = {}
	end
end

function metatable:__index(key)
	return rawget(methods, key) or pool[key]
end

-- Registra o processo
commands = setmetatable(methods, metatable)

-- Retorna o processo para confirmar que houve a execução sem erros
return commands
