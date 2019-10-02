function isPrivateChat(channel)
	return channel and channel.type == enums.channelType.private or false
end

return isPrivateChat
