local methods = {}
local metatable = {}
local pool = {}
pool.list = {}
pool.aliases = {}
pool.categories = {}

function methods:create(data)
	data = data or {}

	local name = assert(data.name, "Missing name for command on create")
	local category = assert(data.category, "Missing category for command")
	category = category and category:match("%w+")

	if category and not inList(category, pool.categories) then
		table.insert(pool.categories, category)
	end

	pool.list[name] = data

	return setmetatable(data, metatable)
end

function methods:accept(...)
	assert(self.name, "Must create command first")

	local list = {...}

	assert(#list > 0, "Must provide an alias")

	for _, alias in next, list do
		local exists = pool.aliases[alias]

		if exists then
			printf("Alias %s already exists for command %s", alias, exists.name)
			return false
		end

		pool.aliases[alias] = self.name
	end
end

function methods:getCommand(name)
	local command = pool.list[name]
	local aliases = pool.aliases[name]

	return command or (aliases and pool.list[aliases])
end

function methods:flushList()
	for list, _ in next, pool do
		pool[list] = {}
	end
end

function metatable:__index(key)
	return rawget(methods, key)
	or rawget(pool, key)
end

worker = setmetatable(methods, metatable)

return worker
