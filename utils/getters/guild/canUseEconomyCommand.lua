function canUseEconomyCommand(command, member, guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local memberEconomy, guildEconomy = getMemberEconomy(member, guild)
	local commandsUsed = memberEconomy:get("commandsUsed")
	local commandData = worker:getCommand(command)
	local commandName = commandData and commandData.name

	if not commandData then
		client:error("Could not find command '%s'", command)
		return false
	end

	commandData = config.defaultEconomy.actions[commandName]
	and guildEconomy:get("actions"):raw()[commandName]

	if not commandData then
		client:error("Could not find action '%s'", commandName)
		return false
	end

	local permit = false
	local newTime = os.time()
	local cooldown = commandData.cooldown or 0
	local commandUsedData = commandsUsed:raw()[commandName]
	local elapsedTime, tick

	if commandUsedData then
		tick = commandUsedData.tick
		elapsedTime = newTime - tick

		if not tick then
			permit = true
		elseif elapsedTime >= cooldown then
			permit = true
		end
	else
		permit = true
	end

	return permit, not permit and (cooldown - elapsedTime)
end

return canUseEconomyCommand
