function getMemberEconomy(member, guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local data = getGuildEconomy(guild)
	local memberData = data:get("users"):get(member.id)

	return memberData, data
end

return getMemberEconomy
