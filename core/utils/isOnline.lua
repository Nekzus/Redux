function isOnline(member)
	return member.status ~= "offline"
end

return isOnline
