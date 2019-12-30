local methods = {}
local metatable = {}

function metatable:__index(...)
	return rawget(methods, ...)
end

function metatable:__newindex(...)
	return rawset(methods, ...)
end

function metatable:__call(...)
	return not self.tick
	and setmetatable({
		tick = os.clock(),
		tasks = {}
	}, metatable)
	or self:fire(...)
end

function methods:fire(...)
	local result

	for _, task in next, self.tasks do
		result = {task(...)}
	end

	return #result > 0 and unpack(result) or nil
end

function methods:task(func)
	table.insert(self.tasks, func)
end

function methods:clear()
	self.tasks = {}
end

flare = setmetatable(methods, metatable)

return flare
