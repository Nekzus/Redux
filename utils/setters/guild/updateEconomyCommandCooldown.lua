function updateEconomyCommandCooldown(command, member, guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local memberEconomy, guildEconomy = getMemberEconomy(member, guild)
	local commandsUsed = memberEconomy:get("commandsUsed")
	local commandData = worker:getCommand(command)
	local commandName = commandData and commandData.name

	commandData = config.templates.economy.actions[commandName]
	and guildEconomy:get("actions"):raw()[commandName]

	if not commandData then
		client:error("Could not find command '%s'", command)
		return false
	end

	local commandUsedData = commandsUsed:get(commandName)

	commandUsedData:set("tick", os.time())
	clearEconomyCommandsUsed(member, guild)
end

return updateEconomyCommandCooldown
