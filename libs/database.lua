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

-- Lê o conteúdo de um arquivo
local function readFile(path)
	assert(
		path and isFile(path),
		format("Path for file not found: %s", path)
	)

	local file = io.open(path, "rb")

	if not file then
		return nil
	end

	local content = file:read("*a")
	file:close()

	return content
end

local function writeFile(path, text)
	assert(
		path and isFile(path),
		format("Path for file not found: %s", path)
	)

	assert(
		text and type(text) == "string",
		format("Text must be a string in writeFile for path: %s", path)
	)

	local file, err = io.open(path, "w")

	if not file then
		printf("Could not writeFile for path %s because: %s", path, err)
		return nil
	end

	file:write(text)
	file:close()
end

-- Carrega as informações de um arquivo que foi salvo no caminho específicado
function main.load(filePath)
	filePath = assert(
		filePath and type(filePath) == "string" and format("./saves/%s.txt", filePath),
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

-- Salva as informações de um arquivo no caminho específicado
function main.save(data, filePath)
	assert(
		data and type(data) == "table" and data,
		"Data must be a table-type for save()"
	)

	filePath = assert(
		filePath and format("./saves/%s.txt", filePath),
		format("Could not parse file location in load() for: %s", filePath)
	)

	if not isFile(filePath) then
		printf("File path not found for: %s", filePath)
	end

	writeFile(filePath, serpent.dump(data))

	return true
end

-- Registra o processo
db = main

-- Retorna o processo para confirmar que houve a execução sem erros
return db
