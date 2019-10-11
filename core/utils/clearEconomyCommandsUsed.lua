function clearEconomyCommandsUsed(member, guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local memberEconomy, guildEconomy = getMemberEconomy(member, guild)
	local commandsUsed = memberEconomy:get("commandsUsed")

	for k, v in next, commandsUsed:raw() do
		if canUseEconomyCommand(k, member, guild) == true then
			commandsUsed:set(k, nil)
		end
	end
end

return clearEconomyCommandsUsed
