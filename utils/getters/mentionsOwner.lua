function mentionsOwner(message)
	if message.mentionedUsers:iter()() == message.guild.owner.member then
		return true
	end

	return false
end

return mentionsOwner
