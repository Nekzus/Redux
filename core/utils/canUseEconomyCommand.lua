function canUseEconomyCommand(command, member, guild)
	local memberEconomy, guildEconomy = getMemberEconomy(member, guild)
	local commandsUsed = memberEconomy:get("commandsUsed")
	local commandData = commands.list[command]

	if not commandData then
		printf("Could not find command '%s'", command)

		return false
	end

	if commandData.alias then
		command = commandData.origin
		commandData = commands.list[command]
	end

	commandData = config.economyDefault.actions[command] and guildEconomy:get("actions"):raw()[command]

	if not commandData then
		printf("Could not find action '%s'", command)

		return false
	end

	local permit = false
	local newTime = os.time()
	local cooldown = commandData.cooldown or 0
	local commandUsedData = commandsUsed:raw()[command]
	local elapsedTime, lastUse

	if commandUsedData then
		lastUse = commandUsedData.lastUse
		elapsedTime = newTime - lastUse

		if not lastUse then
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
