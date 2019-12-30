local methods = {}
local metatable = {}

function methods:post(content, embed, channel)
	local result = {}

	if content then
		assert(type(content) == "string", "Text must be a string")
		result.content = content
	end

	if embed then
		assert(type(embed) == "table", "Embed must be a table")
		result.embed = embed
	end

	return setmetatable({
		message = channel:send(result)
	}, metatable)
end

function methods:getMessage()
	assert(self.message, "Must create object first")

	return self.message
end

function methods:update(content, embed)
	assert(self.message, "Must create object first")

	if embed ~= true then
		self.message:setEmbed(embed)
	end

	if content ~= true then
		self.message:setContent(content)
	end
end

function methods:delete()
	assert(self.message, "Must create object first")

	return self.message:delete()
end

function methods:addReaction(emoji)
	assert(self.message, "Must create object first")

	return self.message:addReaction(emoji)
end

function methods:removeReaction(emoji, userId)
	assert(self.message, "Must create object first")

	return self.message:removeReaction(emoji, userId)
end

function methods:clearReacts()
	assert(self.message, "Must create object first")

	return self.message:clearReactions()
end

function methods:pin()
	assert(self.message, "Must create object first")

	local message = self.message
	local channel = message.channel
	local pinned = channel:getPinnedMessages():toArray()

	if #pinned >= 50 then
		pinned[1]:unpin()
	end

	return message:pin()
end

function methods:unpin()
	assert(self.message, "Must create object first")

	local message = self.message

	if message.pinned then
		message:unpin()
	end

	return true
end

function metatable:__index(...)
	return rawget(methods, ...)
end

function metatable:__newindex(...)
	return rawset(methods, ...)
end

bird = setmetatable(methods, metatable)

return bird
