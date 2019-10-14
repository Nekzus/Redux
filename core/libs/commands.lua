commands = {list = {}, temp = {}}
commands.__index = commands

function commands:create(data)
	local name = assert(data.name, "Missing data for command at commands:add(...)")

	self.list[name] = data
	self.last = name
	self.temp = {}

	return setmetatable(data, commands)
end

function commands:accept(...)
	local list = {...}

	if #list == 0 then
		return false
	end

	for _, alias in next, list do
		assert(type(alias) == "string", "Invalid name type at commands:accept()")

		if self.list[alias] then
			printf("Alias %s is already defined for %s", alias, self.name)
		else
			local command = deepcopy(commands.list[self.name])

			if not self.aliases then
				self.aliases = {}
			end

			insert(commands.list[self.name].aliases, alias)
			command.alias = true
			command.aliases = nil
			command.origin = self.name
			commands.list[alias] = command
		end
	end

	return true
end

local function contains(list, base)
	for key, value in next, base do
		if not list[key] or list[key] ~= value then
			return false
		end
	end

	return true
end

local function getKeys(list, base)
	local result = {}

	for key, value in next, base do
		if list[value] then
			insert(result, list[value])
		end
	end

	return result
end

function commands:getList(mode, ...)
	local args = {...}
	local result = {}

	mode = mode or full

	if mode == "full" then
		return commands.list
	elseif mode == "basic" then
		for _, command in next, commands.list do
			insert(result, getKeys(command, {"name", "desc", "usage", "level"}))
		end
	elseif mode == "with" then
		local code = ""

		for i = 1, #args, 2 do
			code = format("%s-%s:%s", code, args[i], args[i + 1])
		end

		local cached = self.temp[code]

		if cached then
			return cached
		else
			for _, command in next, commands.list do
				local contains = true

				for i = 1, #args, 2 do
					local key = args[i]
					local value = args[i + 1]

					if not (command[key] and command[key] == value) then
						contains = false

						break
					end
				end

				if contains then
					insert(result, command)
				end
			end

			self.temp[code] = result
		end
	end
end

function commands:flushList()
	for key, command in next, commands.list do
		commands.list[key] = nil
	end

	commands.list = {}
end

return commands
