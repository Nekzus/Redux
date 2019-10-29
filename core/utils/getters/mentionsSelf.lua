function mentionsSelf(message)
	if message.mentionedUsers:iter()() == message.author then
		return true
	end

	return false
end

return mentionsSelf
