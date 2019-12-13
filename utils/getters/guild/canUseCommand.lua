function canUseCommand(command, member)
	local usersData = saves.temp:get("users")
	local userData = usersData:get(member.id)
	local commandsUsed = userData:get("commandsUsed")
	local commandData = worker:getCommand(command)
	local commandName = commandData and commandData.name

	if not commandData then
		printf("Could not find command '%s'", command)
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

return canUseCommand
