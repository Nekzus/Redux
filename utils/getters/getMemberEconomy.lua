function getMemberEconomy(member, guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local guildData = getGuildEconomy(guild)
	local memberData = guildData:get("users"):get(member.id)

	return memberData, guildData
end

return getMemberEconomy
