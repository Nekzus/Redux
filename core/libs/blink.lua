blink = {}
blink.__index = blink

function blink:__call(message, timeout, whitelist)
	assert(self.message == nil, "Context for blink already exists")

	whitelist = whitelist or {}

	local mt = setmetatable({
		message = message,
		timeout = timeout or 30,
		lastUse = os.time(),
		whitelist = whitelist,
		active = {},
	}, blink)

	reactionsCallback[message.id] = mt

	return mt
end

function blink:on(emojiId, func)
	assert(self.message, "Must create blink context with constructor")

	self.active[emojiId] = func
end

function blink:close()
	assert(self.message, "Must create blink context with constructor")

	reactionsCallback[message.id] = {}
end

function blink:raw()
	assert(self.message, "Must create blink context with constructor")

	return self.active
end

blink = setmetatable({}, blink)

return blink
