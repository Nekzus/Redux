local methods = {}
local metatable = {}
local directory = "./saves/"
local extension = ".bin"
local lifetime = 30

local ant = ant or require("./libs/ant.lua")
local serpent = serpent or require("./deps/serpent.lua")

local function serialize(data)
	return serpent.dump(data)
end

local function deserialize(plain)
	return loadstring(text)()
end

local function isFile(path)
	assert(type(path) == "string", "Path must be a string")

	local file = io.open(path, "rb")

	return file and file:close() and true or false
end

local function readFile(path)
	assert(type(path) == "string", "Path must be a string")

	local file = io.open(path, "rb")
	local result = file and file:read("*a")

	return file and file:close() and deserialize(result) or nil
end

local function writeFile(path, data)
	assert(type(path) == "string", "Path must be a string")
	assert(type(data) == "table", "Data must be a table")

	local file = io.open(path, "wb")
	local data = file and serialize(data)

	return file and file:write(data) and file:close() and true or false
end

function methods:save()
	assert(self.path, "Must create object first")

	return self.data and writeFile(self.path, self.data:raw())
end

function methods:load()
	assert(self.path, "Must create object first")

	return self.data and readFile(self.path)
end

function methods:update()
	assert(self.path, "Must create object first")

	self.tick = os.time()
	self.data = self.data or ant(readFile(self.path))

	return self.tick
end

function methods:get(paths, default)
	assert(self.path, "Must create data with createor first")

	self:update()

	return self.data:get(paths, default)
end

function methods:set(key, value)
	assert(self.path, "Must create object first")

	self:update()

	return self.data:set(key, value)
end

function methods:raw()
	assert(self.path, "Must create object first")

	self:update()

	return self.data:raw()
end

function methods:track()
	assert(self.path, "Must create object first")

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

function methods:untrack()
	assert(self.path, "Must create object first")

	if not self.handler:is_closing() then
		self.handler:close()
		self.handler = nil
	end
end

function methods:delete()
	assert(self.path, "Must create object first")

	local success, err = os.remove(self.path)

	if not success then
		printf("Could not delete file at path %s: %s", self.path, err)
		return false
	end

	pool[self.path] = nil
	self.path = nil

	return true
end

function methods:saveAll()
	for _, data in next, pool do
		data:save()
	end
end

function metatable:__call(path)
	assert(type(path) == "string", "Path must be a string")

	if not isFile(path) then
		writeFile(path, {})
	end

	local result = pool[path]

	if result then
		return result
	end

	result = {}
	result.path = path
	result.tick = os.time()
	result = setmetatable(result, metatable)
	pool[path] = result
	result:update()
	result:wakeUp()

	return result
end

function metatable:__index(key)
	return rawget(methods, key)
	or rawget(pool, key)
end

think = setmetatable(methods, metatable)

return think
