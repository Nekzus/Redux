function updateEconomyCommandCooldown(command, member, guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local memberEconomy, guildEconomy = getMemberEconomy(member, guild)
	local commandsUsed = memberEconomy:get("commandsUsed")
	local commandData = commands.list[command]

	if commandData.alias then
		command = commandData.origin
		commandData = commands.list[command]
	end

	commandData = config.economyDefault.actions[command] and guildEconomy:get("actions"):raw()[command]

	if not commandData then
		printf("Could not find command '%s'", command)
		return false
	end

	local commandUsedData = commandsUsed:get(command)

	commandUsedData:set("lastUse", os.time())
	clearEconomyCommandsUsed(member, guild)
end

return updateEconomyCommandCooldown
