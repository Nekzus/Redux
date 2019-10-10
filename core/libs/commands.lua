-- backup bot https://github.com/Lautenschlager-id/BackupBot/blob/master/bot.lua

commands = {list = {}, temp = {}, last = ""}
commands.__index = commands

function commands:create(data)
	name = data.name
	assert(name, "Missing data for command at commands:add(...)")
	self.list[name] = data
	self.last = name
	self.temp = {}
	return setmetatable(data, commands)
end

function commands:accept(...)
	local list = {...}

	if #list > 0 then
		for _, n in next, list do
			assert(type(n) == "string", "Invalid name variation at commands:accept(...)")
			if self.list[n] then
				printf("Alias %s is already defined for %s", n, self.name)
			else
				local copy = deepcopy(commands.list[self.name])

				if not self.aliases then
					self.aliases = {}
				end

				insert(commands.list[self.name].aliases, n)
				copy.alias = true
				copy.aliases = nil
				copy.origin = self.name
				commands.list[n] = copy
			end
		end

		return true
	end

	return false
end

local function alike(list, base)
	for k, v in next, base do
		if list[k] == nil or list[k] ~= v then
			return false
		end
	end

	return true
end

local function collectKeys(list, base)
	local r = {}

	for k, v in next, base do
		if list[v] then
			insert(r, v)
		end
	end

	return r
end

function commands:getList(mode, ...)
	mode = mode or 0
	local r = {}
	local args = {...}

	if mode == "full" then -- get full list
		return commands.list

	elseif mode == "basic" then -- name, desc, usage, level
		for k, v in next, commands.list do
			insert(r, collectKeys(v, {"name", "desc", "usage", "level"}))
		end

	elseif mode == "level" then -- get commands permitted by level
		local byLevel = args[1] or 0

		for k, v in next, commands.list do
			if alike(v, {level = byLevel}) then
				insert(r, collectKeys(v, {"name", "desc", "usage", "level"}))
			end
		end

	elseif mode == "has" then -- get commands matching a condition
		-- Creates a reader to avoid performing the same operation multiple times
		local conditionKey = ""

		for i = 1, #args, 2 do
			conditionKey = format("%s-%s:%s", conditionKey, args[i], args[i + 1])
		end

		-- Checks whether the current operation has been performed and returns it if so
		local conditionExists = self.temp[conditionKey]

		if conditionExists then
			return conditionExists
		else
			for k, v in next, commands.list do
				local isValid = false

				for i = 1, #args, 2 do
					local hasKey = args[i]
					local hasVal = args[i + 1]

					if not (v[hasKey] and v[hasKey] == hasVal) then
						break
					end

					isValid = true
				end

				insert(r, v)
			end

			self.temp[conditionKey] = r
		end
	end

	return r
end

function commands:flushList()
	for k, v in next, commands.list do
		commands.list[k] = nil
	end

	commands.list = {}
end

return commands
