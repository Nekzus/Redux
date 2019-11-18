-- Cria um construtor para registrar os métodos
local main = {}

-- Carrega os dados da modula serpent que converte um vetor em texto
serpent = serpent or require("./libs/serpent.lua")

-- Função local para checar se o caminho para um arquivo é válido
local function isFile(path)
	local file = io.open(path, "rb")

	if file then
		file:close()
	end

	return file ~= nil
end
--[[local function isFile(path)
	local file = fs.openSync(path, "r")

	if file then
		fs.closeSync(file)
		return true
	end

	return false
end]]

-- Lê o conteúdo de um arquivo
local function readFile(path)
	local file = io.open(path, "rb")

	if not file then
		return nil
	end

	local content = file:read("*a")
	file:close()

	return content
end

-- Carrega as informações de um arquivo que foi salvo no caminho específicado
function main.load(filePath)
	filePath = assert(
		filePath and format("./saves/%s.txt", filePath),
		format("Could not parse file location in load() for: %s", filePath)
	)

	if not isFile(filePath) then
		printf("File path not found for: %s", filePath)
	end

	local file = assert(
		readFile(filePath),
		format("Could not open file: %s", filePath)
	)

	local result = loadstring(file)

	return result()
end
--[[function main.load(filePath)
	filePath = assert(filePath and format("./saves/%s.txt", filePath), "Could not parse file location in load()")
	assert(isFile(filePath), "Could not find file in location for load()")

	local file = assert(fs.openSync(filePath, "r"), format("Could not open file for filePath %s", filePath))
	local result = loadstring(fs.readSync(file))
	print(result)

	fs.closeSync(file)

	return result()
end]]

-- Salva as informações de um arquivo no caminho específicado
function main.save(data, filePath)
	assert(data and type(data) == "table", "Data must be a table-type for save()")
	filePath = assert(filePath and format("./saves/%s.txt", filePath), "Could not parse file location in save()")
	assert(isFile(filePath), "Could not find file in location save()")

	local file = assert(fs.openSync(filePath, "w"), format("Could not open file for filePath %s", filePath))

	fs.writeSync(file, - 1, serpent.dump(data))
	fs.closeSync(file)

	return true
end

-- Registra o processo
db = main

-- Retorna o processo para confirmar que houve a execução sem erros
return db
