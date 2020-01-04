local methods = {}
local metatable = {}
local pool = {}

function methods:on(emojiId, func)
	assert(self.message, "Must create object first")

	self.active[emojiId] = func
end

function methods:clear()
	assert(self.message, "Must create object first")

	self.active = {}
end

function methods:close()
	assert(self.message, "Must create object first")

	pool[self.message.id] = {}
end

function methods:raw()
	return self.message and self or pool
end

local function untrack(self)
	assert(self.message, "Must create object first")

	if self.handler and not self.handler:is_closing() then
		self.handler:close()
		self.handler = nil
	end
end

local function track(self)
	assert(self.message, "Must create object first")

	if self.handler then
		untrack(self)
	end

	self.handler = timer.setTimeout(config.timeouts.cleaner.value * 1000, function()
		if ((os.time() - self.tick) > self.lifetime) then
			untrack(self)
			pool[self.message.id] = nil
		else
			untrack(self)
			track(self)
		end
	end)
end

function metatable:__call(message, lifetime, whitelist)
	assert(self.message == nil, "Object already exists")

	local result = setmetatable({
		tick = os.time(),
		message = message,
		lifetime = lifetime or config.timeouts.reaction.value,
		whitelist = whitelist or {},
		active = {},
	}, metatable)

	pool[message.id] = result
	track(result)

	return result
end

function metatable:__index(...)
	return rawget(methods, ...)
	or rawget(pool, ...)
end

blink = setmetatable(methods, metatable)

return blink
