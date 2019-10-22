local main = {}
main.__index = main

randomSeed(os.time())

function main:__call(first, ...)
	if self.mode == 1 then
		for _, func in next, self.tasks do
			func(first, ...)
		end
	elseif self.mode == 2 then
		for _, func in next, self.tasks do
			local ret = {func(first, ...)}

			if #ret > 0 then
				return unpack(ret)
			else
				return nil
			end
		end
	end

	return setmetatable({
		mode = max(0, min(2, first or 1)),
		tasks = {}
	}, main)
end

function main:task(func)
	local index = tostring(func)
	local tasks = self.tasks
	local ret = {}

	tasks[index] = func

	function ret:close()
		tasks[index] = nil
	end

	return ret
end

function main:flush()
	for k, v in next, self.tasks do
		self.tasks[k] = nil
	end

	self.tasks = {}
end

flare = setmetatable({}, main)

return flare
