db = {}
serpent = serpent or require("./core/libs/serpent.lua")

local function isFile(path)
	local file = fs.openSync(path, "r")

	if file then
		fs.closeSync(file)
		return true
	end

	return false
end

function db.load(filePath)
	filePath = assert(filePath and format("./saves/%s.txt", filePath), "[1] Invalid file path for .load()")
	assert(isFile(filePath), "[2] Invalid file path for .load()")

	local result
	local file = fs.openSync(filePath, "r")

	assert(file, format("Could not open file: %s", err))
	result = loadstring(fs.readSync(file))
	fs.closeSync(file)

	return result()
end

function db.save(data, filePath)
	assert(data and type(data) == "table", "Data must be a table in .load()")
	filePath = assert(filePath and format("./saves/%s.txt", filePath), "[1] Invalid file path for .load()")
	assert(isFile(filePath), "[2] Invalid file path for .load()")

	local result
	local file = fs.openSync(filePath, "w")

	assert(file, format("Could not open file: %s", err))

	local encoded = serpent.dump(data)

	fs.writeSync(file, - 1, encoded)
	fs.closeSync(file)

	return true
end

return db
