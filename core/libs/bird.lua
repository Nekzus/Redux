bird = {}
bird.__index = bird

function bird:post(text, embed, channel)
	local reply = {}

	if text then
		assert(type(text) == "string", "Text must be a string")
		reply.content = text
	end

	if embed then
		assert(type(embed) == "table", "Embed must be a table")
		reply.embed = embed
	end

	return setmetatable({message = channel:send(reply)}, bird)
end

function sanityCheck(self)
	assert(self.message, "Must use :post() first")
end

function bird:getMessage()
	sanityCheck(self)

	return self.message
end

function bird:update(content, embed)
	sanityCheck(self)

	if content ~= true then
		self.message:setContent(content)
	end

	if embed ~= true then
		self.message:setEmbed(embed)
	end
end

function bird:delete()
	sanityCheck(self)

	return self.message:delete()
end

function bird:react(emoji)
	sanityCheck(self)

	return self.message:addReaction(emoji)
end

function bird:clearReacts()
	sanityCheck(self)

	return self.message:clearReactions()
end

function bird:unreact(emoji, userId)
	sanityCheck(self)

	return self.message:removeReaction(emoji, userId)
end

function bird:pin()
	sanityCheck(self)

	return self.message:pin()
end

function bird:unpin()
	sanityCheck(self)

	return self.message:unpin()
end

function countListItems(list)
	local count = 0

	for k, v in next, list do
		count = count + 1
	end

	return count
end

return bird
