function hasPermissions(member, channel, list)
	local perms = member:getPermissions(channel):toTable()
	local missing = {}
	local text = ""

	for perm, value in next, list do
		if not perms[value] then
			insert(missing, value)

			if text ~= "" then
				text = format("%s, %s", text, format("${%s}", value))
			else
				text = format("${%s}", value)
			end
		end
	end

	if #missing == 0 then
		return true
	else
		return false, {list = missing, text = text}
	end
end

return hasPermissions

--[[
addReactions
administrator
attachFiles
banMembers
changeNickname
connect
createInstantInvite
deafenMembers
embedLinks
kickMembers
manageChannels
manageEmojis
manageGuild
manageMessages
manageNicknames
manageRoles
manageWebhooks
mentionEveryone
moveMembers
muteMembers
prioritySpeaker
readMessageHistory
readMessages
sendMessages
sendTextToSpeech
speak
useExternalEmojis
useVoiceActivity
viewAuditLog
]]
