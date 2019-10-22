local main = {}
main.__index = main

function main:post(text, embed, channel)
	local reply = {}

	if text then
		assert(type(text) == "string", "Text must be a string")
		reply.content = text
	end

	if embed then
		assert(type(embed) == "table", "Embed must be a table")
		reply.embed = embed
	end

	return setmetatable({
		message = channel:send(reply)
	}, main)
end

function main:getMessage()
	assert(self.message, "Must create main context with :post() first")

	return self.message
end

function main:update(content, embed)
	assert(self.message, "Must create main context with :post() first")

	if content ~= true then
		self.message:setContent(content)
	end

	if embed ~= true then
		self.message:setEmbed(embed)
	end
end

function main:delete()
	assert(self.message, "Must create main context with :post() first")

	return self.message:delete()
end

function main:react(emoji)
	assert(self.message, "Must create main context with :post() first")

	return self.message:addReaction(emoji)
end

function main:clearReacts()
	assert(self.message, "Must create main context with :post() first")

	return self.message:clearReactions()
end

function main:unreact(emoji, userId)
	assert(self.message, "Must create main context with :post() first")

	return self.message:removeReaction(emoji, userId)
end

function main:pin()
	assert(self.message, "Must create main context with :post() first")

	return self.message:pin()
end

function main:unpin()
	assert(self.message, "Must create main context with :post() first")

	return self.message:unpin()
end

bird = main

return bird
