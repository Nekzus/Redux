-- Cria um construtor para registrar os métodos
local main = {}
main.__index = main

-- Carrega os dados da modula serpent que converte um vetor em texto
local mp = mp or require("./libs/msgPack.lua")

-- Função local para checar se o caminho para um arquivo é válido
local function isFile(path)
	local file = io.open(path, "rb")

	if file then
		file:close()
		return true
	end

	return false
end

-- Retorna o conteúdo de um arquivo
local function loadFile(path)
	assert(
		path and isFile(path),
		format("Path for file not found: %s", path)
	)

	local file = io.open(path, "rb")
	local result

	if file then
		result = mp.unpack(file:read("*a"))
		file:close()
	end

	return result
end

-- Modifica o conteúdo de um arquivo
local function saveFile(path, list)
	assert(path and isFile(path), format("Path for file not found: %s", path))
	assert(list and type(list), "List must be a table for saveFile")

	local file = io.open(path, "wb")

	if file then
		file:write(mp.pack(list))
		file:close()
		return true
	end

	return false
end

function main:__call(path)
	return setmetatable({
		path = path,
		ticket = 0,
	}, main)
end

function main:open(duration)
	print("OPENED EDIT")
	duration = duration or 30
	self.data = self.data or loadFile(self.path)
	self.ticket = self.ticket + 1
	local ticket = self.ticket

	if self.handler then
		print("RENEWING TIMER")
		self.handler:stop()
		self.handler:close()
	end

	self.handler = timer.setTimeout(duration * 1000, function()
		if self.ticket == ticket then
			print("LIFETIME REACHED, AUTO-SAVING")
			self:close()
		end
	end)

	return self.data
end

function main:close()
	local success = assert(
		saveFile(self.data),
		"Could not close connection to database"
	)

	self.data = nil
	self.ticket = self.ticket + 1

	if self.handler then
		print("ENDING LIFETIME")
		self.handler:stop()
		self.handler:close()
	end

	self.handler = nil
	print("EDIT CLOSED")

	return true
end

ndb = main
