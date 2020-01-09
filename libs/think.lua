local methods = {}
local metatable = {}
local directory = "./saves/"
local extension = ".bin"
local lifetime = config.timeouts.saver.value
local pool = {}

local ant = ant or require("./libs/ant.lua")

local function serialize(data)
	return serpent.dump(data)
end

local function deserialize(plain)
	return loadstring(plain)()
end

local function isFile(path)
	assert(type(path) == "string", "Path must be a string")

	return fs.existsSync(path)
end

local function readFile(path)
	assert(type(path) == "string", "Path must be a string")

	return deserialize(fs.readFileSync(path))
end

local function writeFile(path, data)
	assert(type(path) == "string", "Path must be a string")
	assert(type(data) == "table", "Data must be a table")

	return fs.writeFileSync(path, serialize(data))
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

local function untrack(self)
	assert(self.handler, "Must create object first")

	if self.handler and not self.handler:is_closing() then
		self.handler:close()
		self.handler = nil
	end
end

local function track(self)
	assert(self.path, "Must create object first")

	if self.handler then
		untrack(self)
	end

	self.handler = timer.setTimeout(lifetime * 1000, function()
		if (self.path == nil or not isFile(self.path)) and self.handler then
			untrack(self)
			return false
		end

		self:save()

		if ((os.time() - self.tick) > lifetime) then
			untrack(self)
			self.data = nil
		else
			untrack(self)
			track(self)
		end
	end)
end

function methods:delete()
	assert(self.path, "Must create object first")

	fs.unlinkSync(self.path)
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
	track(result)

	return result
end

function metatable:__index(...)
	return rawget(methods, ...)
	or rawget(pool, ...)
end

think = setmetatable(methods, metatable)

return think
