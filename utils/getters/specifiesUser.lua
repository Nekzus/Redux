function specifiesUser(message)
	if not message.mentionsEveryone and message.mentionedUsers:iter()() then
		return true
	end

	return false
end

return specifiesUser
