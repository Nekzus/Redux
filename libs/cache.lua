--[[
	Parte responsável por criar ou retornar caminhos conforme é feito o acesso
	dentro de uma table.


	Exemplo:

	local crafting = cache() -- cache{}
	local spear = crafting:get("spear/items")

	spear:set("stick", 2)
	spear:set("stone", 1)

	for key, value in next, spear:raw() do
	print(key, value)
	end

	>> stick  2
	>> stone  1
]]

-- Cria um construtor para registrar os métodos e metamétodos
local methods = {}
local metatable = {}

-- Função para realizar o acesso e a criação dentro do vetor passado
function access(list, paths, default)
	assert(list and type(list) == "table", "List must be a table in access")
	assert(paths and type(paths) == "string", "Paths must be a string path for access")

	local result = {}

	for _, path in next, paths:split(";") do
		local last = list

		for _, dir in next, path:split("/") do
			local inners = dir:split(",")

			if #inners == 1 then
				local inner = inners[1]

				if last[inner] then
					if last[inner] == false then
						last[inner] = false
					end
				elseif default ~= nil then
					last[inner] = default
				end

				last = last[inner]
			else
				for _, inner in next, inners do
					if last[inner] then
						last = last[inner]
					else
						last[inner] = {}
						last = last[dir]
					end
				end
			end
		end

		insert(result, last)
	end

	return unpack(result)
end

-- Retorna o acesso dentro de uma table após a criação conforme passada a string
function methods:get(paths, default)
	assert(self.list, "Must create thread first")
	assert(paths, "Must provide a valid path")

	local result = access(self.list, paths, default or {})

	if result then
		if type(result) == "table" then
			return setmetatable({
				list = result,
			}, metatable)
		else
			return result
		end
	else
		return false
	end
end

-- Define uma chave e um valor dentro de uma table durante o acesso
function methods:set(key, value)
	assert(self.list, "Must create thread first")
	assert(key, "Must provide a valid key")

	self.list[key] = value

	return self.list[key] or value
end

-- Retorna a table principal que contém os dados modificados do objeto
function methods:raw()
	assert(self.list, "Must create thread first")

	return self.list
end

-- Função construtora que retorna ou cria os métodos dentro de uma table
function metatable:__call(list)
	assert(self.list == nil, "Thread already exists")

	list = list and type(list) == "table" and list or {}

	return setmetatable({
		list = list
	}, metatable)
end

-- Associa os métodos ao objeto
function metatable:__index(key)
	local method = rawget(methods, key)

	if method then
		return method
	end
end

-- Registra o processo
cache = setmetatable(methods, metatable)

-- Retorna o processo para confirmar que houve a execução sem erros
return cache

--[[
-- Cria um construtor para registrar os métodos e metamétodos
local _cache = {}
_cache.__index = _cache

-- Função para realizar o acesso e a criação dentro do vetor passado
function access(list, paths, default)
	assert(list and type(list) == "table", "List must be a table in access()")
	assert(paths and type(paths) == "string", "Paths must be a string path for access()")

	local result = {}
	local paths = paths:split(";")

	for _, path in next, paths do
		local last = list
		local dirs = path:split("/")

		for _, dir in next, dirs do
			local inners = dir:split(",")

			if #inners == 1 then
				local inner = inners[1]

				if last[inner] then
					if last[inner] == false then
						last[inner] = false
					end
				elseif default ~= nil then
					last[inner] = default
				end

				last = last[inner]
			else
				for _, inner in next, inners do
					if last[inner] then
						last = last[inner]
					else
						last[inner] = {}
						last = last[dir]
					end
				end
			end
		end

		insert(result, last)
	end

	return unpack(result)
end

-- Função construtora que retorna ou cria os métodos dentro do vetor passado
function _cache:__call(list)
	if self.bin then
		print("Thread is already created, use the metamethods")
		return false
	else
		return setmetatable({
			bin = type(list) == "table" and list or {}
		}, _cache)
	end
end

-- Retorna o acesso dentro do vetor após a criação conforme passado via string
function _cache:get(paths, default)
	if self.bin then
		local result = access(self.bin, paths, default or {})

		if result and type(result) == "table" then
			return setmetatable({
				bin = result
			}, _cache)
		else
			return result
		end
	else
		print("Must create a thread first, use cache(table)")
		return false
	end
end

-- Define uma chave e um valor dentro do vetor atualmente acessado
function _cache:set(key, value)
	if self.bin then
		if not key then
			print("Key not found for table index in :set()")

			return false
		end

		self.bin[key] = value
		return self.bin[key] or value
	else
		print("Must create a thread first, use cache(table)")
		return false
	end
end

-- Retorna o vetor principal
function _cache:raw()
	if self.bin then
		return self.bin
	else
		return false
	end
end

-- Registra o processo
cache = setmetatable({}, _cache)

-- Retorna o processo para confirmar que houve a execução sem erros
return cache
]]
