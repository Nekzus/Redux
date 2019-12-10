local methods = {}
local metatable = {}

math.randomseed(os.time())

function methods:task(func)
	local index = tostring(func)
	local tasks = self.tasks
	local result = {}

	tasks[index] = func

	function result:close()
		tasks[index] = nil
	end

	return result
end

function methods:flush()
	for key, value in next, self.tasks do
		self.tasks[key] = nil
	end

	self.tasks = {}
end

function metatable:__call(first, ...)
	if self.mode == 1 then
		for _, func in next, self.tasks do
			func(first, ...)
		end
	elseif self.mode == 2 then
		for _, func in next, self.tasks do
			local result = {func(first, ...)}

			if #result > 0 then
				return unpack(result)
			else
				return nil
			end
		end
	end

	return setmetatable({
		mode = max(0, min(2, first or 1)),
		tasks = {}
	}, metatable)
end

function metatable:__index(key)
	return rawget(methods, key)
end

flare = setmetatable(methods, metatable)

return flare
