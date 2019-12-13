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
	return self.active and self or pool
end

function metatable:__call(message, lifetime, whitelist)
	assert(self.message == nil, "Object already exists")

	local result = setmetatable({
		tick = os.time(),
		message = message,
		lifetime = lifetime or config.timeouts.reaction,
		whitelist = whitelist or {},
		active = {},
	}, metatable)

	pool[message.id] = result

	return result
end

function metatable:__index(key)
	return rawget(methods, key)
	or rawget(pool, key)
end

blink = setmetatable(methods, metatable)

return blink
