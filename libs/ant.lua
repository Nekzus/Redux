local methods = {}
local metatable = {}

function access(list, paths, default)
	assert(list and type(list) == "table", "List must be a table in access")
	assert(paths and type(paths) == "string", "Paths must be a string path for access")

	local result = {}

	for _, path in next, paths:split(";") do
		local last = list

		for _, dir in next, path:split("/") do
			local inners = dir:split(",")

			if #inners == 1 then
				local inner = inners[1]

				if last[inner] then
					if last[inner] == false then
						last[inner] = false
					end
				elseif default ~= nil then
					last[inner] = default
				end

				last = last[inner]
			else
				for _, inner in next, inners do
					if last[inner] then
						last = last[inner]
					else
						last[inner] = {}
						last = last[dir]
					end
				end
			end
		end

		table.insert(result, last)
	end

	return unpack(result)
end

function methods:get(paths, default)
	assert(self.list, "Must create object first")
	assert(paths, "Must provide a valid path")

	local result = access(self.list, paths, default or {})

	if result then
		if type(result) == "table" then
			return setmetatable({
				list = result,
			}, metatable)
		else
			return result
		end
	else
		return false
	end
end

function methods:set(key, value)
	assert(self.list, "Must create object first")
	assert(key, "Must provide a valid key")

	self.list[key] = value

	return self.list[key] or value
end

function methods:raw()
	assert(self.list, "Must create object first")

	return self.list
end

function metatable:__call(list)
	assert(self.list == nil, "Object already exists")

	list = list and type(list) == "table" and list or {}

	return setmetatable({
		list = list
	}, metatable)
end

function metatable:__index(...)
	return rawget(methods, ...)
end

function metatable:__newindex(...)
	return rawset(methods, ...)
end

ant = setmetatable(methods, metatable)

return ant
