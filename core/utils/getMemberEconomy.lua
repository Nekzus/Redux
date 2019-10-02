function getMemberEconomy(member, guild)
	local guildData = getGuildEconomy(guild)
	local memberData = guildData:get("users"):get(member.id)

	return memberData, guildData
end

return getMemberEconomy
