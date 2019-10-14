local main = {}
main.__index = main

function main:__call(message, timeout, whitelist)
	assert(self.message == nil, "Context for main already exists")

	whitelist = whitelist or {}

	local mt = setmetatable({
		message = message,
		timeout = timeout or 30,
		lastUse = os.time(),
		whitelist = whitelist,
		active = {},
	}, main)

	reactionsCallback[message.id] = mt

	return mt
end

function main:on(emojiId, func)
	assert(self.message, "Must create main context with constructor")

	self.active[emojiId] = func
end

function main:close()
	assert(self.message, "Must create main context with constructor")

	reactionsCallback[message.id] = {}
end

function main:raw()
	assert(self.message, "Must create main context with constructor")

	return self.active
end

blink = setmetatable({}, main)

return blink
