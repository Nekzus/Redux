local pool = {}
local methods = {}
local metatable = {}
local directory = "./test/"
local extension = ".bin"
local lifetime = 30

-- Extensão para mapear subdiretórios de uma table
local cache = cache or require("./libs/cache.lua")

-- Extensão para serializar uma table
local serpent = serpent or require("./libs/serpent.lua")

-- Função para serializar uma table
local function serialize(data)
	return serpent.dump(data)
end

-- Função para desserializar uma string
local function deserialize(text)
	return loadstring(text)()
end

-- Função para checar se o caminho para um arquivo é válido
local function isFile(path)
	assert(path and type(path) == "string", "Path must be a string")

	local file = io.open(path, "r")

	return (file and file:close() and true) or false
end

-- Retorna o conteúdo de um arquivo
local function readFile(path)
	assert(path and type(path) == "string", "Path must be a string")

	local file = io.open(path, "rb")
	local result = file and file:read("*a")

	return (file and file:close() and deserialize(result)) or nil
end

-- Atualiza o conteúdo de um arquivo
local function writeFile(path, list)
	assert(path and type(path) == "string", "Path must be a string")
	assert(list and type(list) == "table", "List must be a table")

	local file = io.open(path, "wb")
	local data = file and serialize(list)

	return (file and file:write(data) and file:close() and true) or false
end

-- Salva os dados do objeto atual
function methods:save()
	assert(self.path, "Must create data with constructor first")

	return self.data and writeFile(self.path, self.data:raw())
end

-- Carrega os dados do objeto atual
function methods:load()
	assert(self.path, "Must create data with constructor first")

	self.data = readFile(self.path)

	return self
end

-- Atualiza o último momento de utilização e carrega os dados caso não estiverem carregados
function methods:update()
	assert(self.path, "Must create data with constructor first")

	self.lastUpdate = os.time()
	self.data = self.data or cache(readFile(self.path))
end

-- Modifica uma chave interna do objeto atual
function methods:set(key, value)
	assert(self.path, "Must create data with constructor first")

	self:update()

	return self.data:set(key, value)
end

-- Retorna uma chave interna do objeto atual
function methods:get(paths, default)
	assert(self.path, "Must create data with constructor first")

	self:update()

	return self.data:get(paths, default)
end

-- Retorna a table pura do objeto atual
function methods:raw()
	assert(self.path, "Must create data with constructor first")

	self:update()

	return self.data:raw()
end

function methods:untrack()
	if not self.handler:is_closing() then
		self.handler:close()
		self.handler = nil
	end
end

-- Cria um rastreio para limpar os dados e salvá-los caso o objeto atual estiver
-- inativo por muito tempo, assim, economizando memória
function methods:track()
	self.handler = timer.setTimeout(lifetime * 1000, function()
		if (self.path == nil or not isFile(self.path)) and self.handler then
			self:untrack()
			return false
		end

		self:save()

		if ((os.time() - self.lastUpdate) > lifetime) then
			self:untrack()
			self.data = nil
		else
			self:untrack()
			self:track(lifetime)
		end
	end)
end

-- Deleta os dados armazenados do objeto atual
function methods:delete()
	assert(self.path, "Must create data with constructor first")

	local success, err = os.remove(self.path)

	if not success then
		printf("Could not delete file at path %s because: %s", self.path, err)
		return false
	end

	pool[self.path] = nil
	self.path = nil

	return true
end

-- Salva todos os dados armazenados na pool
function methods:saveAllData()
	for _, data in next, pool do
		data:save()
	end
end

-- Cria o construtor do objeto
function metatable:__call(path)
	assert(path and type(path) == "string", "Path must be a string")

	if not isFile(path) then
		writeFile(path, {})
	end

	local exists = pool[path]

	if exists then
		return exists
	end

	local result = setmetatable({
		path = path,
		lastUpdate = 0,
	}, metatable)

	pool[path] = result
	result:update()
	result:track()

	return result
end

-- Associa os métodos ao objeto
function metatable:__index(key)
	local method = rawget(methods, key)

	if method then
		return method
	end

	local register = rawget(pool, key)

	if register then
		return register
	end
end

-- Registra o processo
db = setmetatable(methods, metatable)

-- Retorna o processo para confirmar que houve a execução sem erros
return db
