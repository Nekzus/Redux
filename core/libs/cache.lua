local main = {}
main.__index = main

function access(tab, paths, default, erase)
	if not (tab and type(tab) == "table"
	and paths and type(paths) == "string") then
		if type(paths) == "table" then
			for k, v in next, paths do
				print(k, v)
			end
		end

		return false, printf("Invalid parameters --> %s - %s", tab, paths)
	end

	local ret = {}
	local paths = paths:split(";")

	for _, path in next, paths do
		local last = tab
		local dirs = path:split("/")

		for _, dir in next, dirs do
			local inners = dir:split(",")

			if #inners == 1 then
				local inner = inners[1]

				if erase then
					last[inner] = nil
				elseif last[inner] then
					if last[inner] == false then
						last[inner] = false -- else last[inner] = last[inner]
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

		insert(ret, last)
	end

	return unpack(ret)
end

function main:__call(tab)
	if self.bin == nil then
		return setmetatable({bin = type(tab) == "table" and tab or {}}, main)
	else
		return false, print("Thread is already created, use :get() or :set()")
	end
end

function main:get(paths, default)
	if self.bin == nil then
		return false, print("Must create a thread first, use main(list)")
	else
		default = default or {}
		local ret = access(self.bin, paths, default)

		if ret and type(ret) == "table" then
			return setmetatable({bin = ret}, main)
		else
			return ret or nil
		end
	end
end

function main:set(key, value)
	if self.bin == nil then
		return false, print("Must create a thread first, use main(list)")
	else
		if not key then
			return false, print("Key not found for table index in :set()")
		end

		self.bin[key] = value

		return self.bin[key] or value
	end
end

function main:raw()
	if self.bin == nil then
		return false, print("Must create a thread first, use main(list)")
	else
		return self.bin
	end
end

cache = setmetatable({}, main)

return cache
