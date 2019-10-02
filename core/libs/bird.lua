local main = {}
main.__index = main

local actives = {}

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

	return setmetatable({message = channel:send(reply)}, main)
end

function sanityCheck(self)
	assert(self.message, "Must use :post() first")
end

function main:getMessage()
	sanityCheck(self)

	return self.message
end

function main:update(content, embed)
	sanityCheck(self)

	if content ~= true then
		self.message:setContent(content)
	end

	if embed ~= true then
		self.message:setEmbed(embed)
	end
end

function main:delete()
	sanityCheck(self)

	return self.message:delete()
end

function main:react(emoji)
	sanityCheck(self)

	return self.message:addReaction(emoji)
end

function main:clearReacts()
	sanityCheck(self)

	return self.message:clearReactions()
end

function main:unreact(emoji, userId)
	sanityCheck(self)

	return self.message:removeReaction(emoji, userId)
end

function main:pin()
	sanityCheck(self)

	return self.message:pin()
end

function main:unpin()
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

bird = main

return bird
