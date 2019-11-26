--[[
	Parte responsável por criar ou retornar caminhos conforme é feito o acesso
	dentro de um vetor.

	Exemplo:

	local recipes = cache() -- or cache({})
	local cakeRecipe = receitas:get("cake/ingredients")

	cakeRecipe:set("milk", "1lt")
	cakeRecipe:set("egg", "4un")
	cakeRecipe:set("butter", "200g")
]]

-- Cria um construtor para registrar os métodos e metamétodos
local _cache = {}
_cache.__index = _cache

-- Função para realizar o acesso e a criação dentro do vetor passado
function access(list, paths, default, delete)
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

				if delete then
					last[inner] = nil
				elseif last[inner] then
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
