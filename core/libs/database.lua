-- Cria um construtor para registrar os métodos
local main = {}

-- Carrega os dados da modula serpent que converte um vetor em texto
serpent = serpent or require("./core/libs/serpent.lua")

-- Função local para checar se o caminho para um arquivo é válido
local function isFile(path)
	local file = fs.openSync(path, "r")

	if file then
		fs.closeSync(file)
		return true
	end

	return false
end

-- Carrega as informações de um arquivo que foi salvo no caminho específicado
function main.load(filePath)
	filePath = assert(filePath and format("./saves/%s.txt", filePath), "Could not parse file location in load()")
	assert(isFile(filePath), "Could not find file in location in load()")

	local result
	local file = fs.openSync(filePath, "r")

	assert(file, format("Could not open file: %s", err))
	result = loadstring(fs.readSync(file))
	fs.closeSync(file)

	return result()
end

-- Salva as informações de um arquivo no caminho específicado
function main.save(data, filePath)
	assert(data and type(data) == "table", "Data must be of table-type in load()")
	filePath = assert(filePath and format("./saves/%s.txt", filePath), "Could not parse file location in save()")
	assert(isFile(filePath), "Could not find file in location save()")

	local result
	local file = fs.openSync(filePath, "w")

	assert(file, format("Could not open file: %s", err))

	local encoded = serpent.dump(data)

	fs.writeSync(file, - 1, encoded)
	fs.closeSync(file)

	return true
end

-- Registra o processo
db = main

-- Retorna o processo para confirmar que houve a execução sem erros
return db
