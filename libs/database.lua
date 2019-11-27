--[[
	Parte responsável por manusear o banco de dados local mantido no bot
	Esse script abre novos canais para editar os dados, e após isso, fecha
	quando for encerrada a utilização, dessa forma, mantendo o uso de memória
	do bot o mais baixo possível

	local info = db("./dir/file.ext")
	local edit = info:open()
	edit.var = 1
	print(edit.var)
	info:close()

	edit = info:open()
	print(edit.var)
	info:close()
]]

-- Cria um construtor para registrar os métodos
local _db = {}
_db.__index = _db

-- Carrega os dados da modula serpent que converte um vetor em texto
local serpent = serpent or require("./libs/serpent.lua")
local cache = cache or require("./libs/cache.lua")

-- Função para checar se o caminho para um arquivo é válido
local function isFile(path)
<<<<<<< Updated upstream
	local file = fs.openSync(path, "r")

	if file then
		fs.closeSync(file)
=======
	local file = io.open(path, "r")

	if file then
		file:close()
>>>>>>> Stashed changes
		return true
	end

	return false
<<<<<<< Updated upstream
end

-- Carrega as informações de um arquivo que foi salvo no caminho específicado
function main.load(filePath)
	filePath = assert(filePath and format("./saves/%s.txt", filePath), "Could not parse file location in load()")
	assert(isFile(filePath), "Could not find file in location for load()")

	local file = assert(fs.openSync(filePath, "r"), format("Could not open file for filePath %s", filePath))
	local result = loadstring(fs.readSync(file))

	fs.closeSync(file)
=======
end

-- Função para checar se um diretório é válido
function isDir(path)
   local success, err, code = os.rename(path, path)

   if not success then
      if code == 13 then
         return true
      end
   end

   return success, err
end

-- Função para serializar uma table
local function serialize(data)
	return serpent.dump(data)
end

-- Função para desserializar uma string
local function deserialize(text)
	return loadstring(text)()
end

-- Retorna o conteúdo de um arquivo
local function readFile(path)
	assert(
		path and isFile(path),
		format("Path for file not found: %s", path)
	)

	local file = io.open(path, "r")

	if not file then
		return nil
	end

	local result = file:read("*a")
	file:close()

	return result
end

-- Modifica o conteúdo de um arquivo
local function writeFile(path, text)
	assert(
		text and type(text) == "string",
		format("Text must be a string in writeFile for path: %s", path)
	)

	local file = io.open(path, "w")

	if not file then
		printf("Could not writeFile for path %s", path)
		return false
	end

	file:write(text)
	file:close()

	return true
end

-- Construtor do objeto
function _db:__call(path, duration)
	-- Caso não existir um objeto, criamos um
	if not isFile(path) then
		local fileName = path:split("/")
		fileName = fileName[#fileName]
		writeFile(path, serialize({}))
	end

	local mt = setmetatable({
		path = path,
		status = 0,
		ticket = 0,
	}, _db)

	if duration then
		mt:open(
			type(duration) == "number" and duration
			or duration == true and 0
			or nil
		)
	end

	return mt
end

function _db:isOpen()
	assert(
		self.path,
		"Must create thread first"
	)

	return self.status == 1
end

function _db:isClosed()
	assert(
		self.path,
		"Must create thread first"
	)

	return self.status == 0
end

function _db:open(duration)
	assert(
		self.status == 0,
		"Channel for data access is already open"
	)

	duration = duration or 30
	self.data = self.data or cache(deserialize(readFile(self.path)))
	self.status = self.data and 1 or 0
	self.ticket = self.ticket + 1
	local ticket = self.ticket

	assert(
		self.status == 1,
		"Could not open channel for data access"
	)

	if self.handler then
		self.handler:stop()
		self.handler = nil
	end

	if duration > 0 then
		self.handler = timer.setTimeout(duration * 1000, function()
			if self.ticket == ticket then
				self:close()
			end
		end)
	end

	return self
end

function _db:save()
	assert(
		self.path,
		"Must create thread first"
	)

	if self:isOpen() then
		local success = assert(
			writeFile(self.path, serialize(self.data:raw())),
			"Could save data to database"
		)
>>>>>>> Stashed changes

		assert(success, "Could not save data")
	end

	return true
end

<<<<<<< Updated upstream
-- Salva as informações de um arquivo no caminho específicado
function main.save(data, filePath)
	assert(data and type(data) == "table", "Data must be a table-type for save()")
	filePath = assert(filePath and format("./saves/%s.txt", filePath), "Could not parse file location in save()")
	assert(isFile(filePath), "Could not find file in location save()")

	local file = assert(fs.openSync(filePath, "w"), format("Could not open file for filePath %s", filePath))

	fs.writeSync(file, - 1, serpent.dump(data))
	fs.closeSync(file)
=======
function _db:close()
	assert(
		self.status == 1,
		"Channel for data access is already closed"
	)

	local success = assert(
		writeFile(self.path, serialize(self.data:raw())),
		"Could not close connection to database"
	)

	self.status = success and 0 or 1
	self.ticket = self.ticket + 1
	self.data = success and nil or self.data

	assert(
		self.status == 0,
		"Could not close channel for data access"
	)

	if self.handler then
		self.handler:stop()
		self.handler = nil
	end

	return true
end

function _db:delete()
	assert(
		self.path,
		"Must create thread first"
	)

	local success, err = os.remove(self.path)

	if not success then
		printf("Could not delete file at path %s because: %s", self.path, err)
		return false
	end
>>>>>>> Stashed changes

	return true
end

function _db:set(key, value)
	assert(
		self.path,
		"Must create thread first"
	)

	if self.status == 0 then
		self:open()
	end

	return self.data:set(key, value)
end

function _db:get(paths, default)
	assert(
		self.path,
		"Must create thread first"
	)

	if self.status == 0 then
		self:open()
	end

	return self.data:get(paths, default)
end

function _db:raw()
	assert(
		self.path,
		"Must create thread first"
	)

	if self.status == 0 then
		self:open()
	end

	return self.data:raw()
end

db = setmetatable({}, _db)

return db
