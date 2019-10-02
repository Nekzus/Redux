local serializer = serializer or require("./core/libs/serpent.lua")

local main = {}

local function isFile(path)
	local file = fs.openSync(path, "r")

	if file then
		fs.closeSync(file)
		return true
	end

	return false
end

function main.load(filePath)
	filePath = assert(filePath and format("./data/%s.txt", filePath), "[1] Invalid file path for .load()")
	assert(isFile(filePath), "[2] Invalid file path for .load()")

	local result
	local file = fs.openSync(filePath, "r")

	assert(file, format("Could not open file: %s", err))
	result = loadstring(fs.readSync(file))
	fs.closeSync(file)

	return result()
end

function main.save(data, filePath)
	assert(data and type(data) == "table", "Data must be a table in .load()")
	filePath = assert(filePath and format("./data/%s.txt", filePath), "[1] Invalid file path for .load()")
	assert(isFile(filePath), "[2] Invalid file path for .load()")

	local result
	local file = fs.openSync(filePath, "w")

	assert(file, format("Could not open file: %s", err))

	local encoded = serializer.dump(data)

	fs.writeSync(file, - 1, encoded)
	fs.closeSync(file)

	return true
end

db = main

return db
