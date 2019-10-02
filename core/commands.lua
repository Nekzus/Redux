-- backup bot https://github.com/Lautenschlager-id/BackupBot/blob/master/bot.lua

commands = {list = {}, last = ""}
commands.__index = commands

function commands:create(data)
	name = data.name
	assert(name, "Missing data for command at commands:add(...)")
	self.list[name] = data
	self.last = name
	return setmetatable(data, commands)
end

function commands:accept(...)
	local list = {...}

	if #list > 0 then
		for _, n in next, list do
			assert(type(n) == "string", "Invalid name variation at commands:accept(...)")
			if self.list[n] then
				printf("Alias '%s' is already defined for '%s'", n, self.name)
			else
				local copy = deepcopy(commands.list[self.name])

				if not self.aliases then self.aliases = {} end
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

function commands:getList(mode, byLevel)
	mode = mode or 0
	local r = {}

	if mode == 0 then -- get full list
		return commands.list
	elseif mode == 1 then -- name, desc, usage, level
		for k, v in next, commands.list do
			insert(r, collectKeys(v, {"name", "desc", "usage", "level"}))
		end
	elseif mode == 2 then -- get commands permitted by level
		byLevel = byLevel or 0

		for k, v in next, commands.list do
			if alike(v, {level = byLevel}) then
				insert(r, collectKeys(v, {"name", "desc", "usage", "level"}))
			end
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
