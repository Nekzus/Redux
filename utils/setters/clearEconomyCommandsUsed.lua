function clearEconomyCommandsUsed(member, guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local memberEconomy, guildEconomy = getMemberEconomy(member, guild)
	local commandsUsed = memberEconomy:get("commandsUsed")

	for command, _ in next, commandsUsed:raw() do
		if canUseEconomyCommand(command, member, guild) == true then
			commandsUsed:set(command, nil)
		end
	end
end

return clearEconomyCommandsUsed
