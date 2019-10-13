local main = {}
main.__index = main

function access(list, paths, default, delete)
	assert(list and type(list) == "table", "List must be a table")
	assert(paths and type(paths) == "string", "Paths must be a string path")

	local result = {}
	local paths = paths:split(";")

	for _, path in next, paths do
		local last = list
		local dirs = path:split("/")

		for _, dir in next, dirs do
			local inners = dir:split(",")

			if #inners == 1 then
				local inner = inners[1]

				if delete then
					last[inner] = nil
				elseif last[inner] then
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

		insert(result, last)
	end

	return unpack(result)
end

function main:__call(list)
	if self.bin == nil then
		return setmetatable({
			bin = type(list) == "table" and list or {}
		}, main)
	else
		print("Thread is already created, use :get() or :set()")

		return false
	end
end

function main:get(paths, default)
	if self.bin == nil then
		print("Must create a thread first, use cache(table)")

		return false
	else
		local result = access(self.bin, paths, default or {})

		if result and type(result) == "table" then
			return setmetatable({
				bin = result
			}, main)
		else
			return result
		end
	end
end

function main:set(key, value)
	if self.bin == nil then
		print("Must create a thread first, use cache(table)")

		return false
	else
		if not key then
			print("Key not found for table index in :set()")

			return false
		end

		self.bin[key] = value

		return self.bin[key] or value
	end
end

function main:raw()
	if self.bin == nil then
		return false
	else
		return self.bin
	end
end

cache = setmetatable({}, main)

return cache
