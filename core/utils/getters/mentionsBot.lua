function mentionsBot(message)
	if message.mentionedUsers:iter()() == client.member then
		return true
	end

	return false
end

return mentionsBot
