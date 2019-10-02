function mentionsOtherBot(message)
	if #message.mentionedUsers == 0 then
		return false
	end

	if message.mentionedUsers:iter()().bot then
		return true
	end

	return false
end

return mentionsOtherBot
