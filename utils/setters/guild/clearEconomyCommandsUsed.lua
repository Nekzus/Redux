function clearEconomyCommandsUsed(member, guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local memberEconomy, guildEconomy = getMemberEconomy(member, guild)
	local commandsUsed = memberEconomy:get("commandsUsed")

	for command, _ in next, commandsUsed:raw() do
		local exists = worker:getCommand(command)
		local canUse = exists and canUseEconomyCommand(command, member, guild)

		if canUse == true or canUse == nil then
			commandsUsed:set(command, nil)
		end
	end
end

return clearEconomyCommandsUsed
