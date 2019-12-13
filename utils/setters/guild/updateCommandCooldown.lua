function updateCommandCooldown(command, member)
	local usersData = saves.temp:get("users")
	local userData = usersData:get(member.id)
	local commandsUsed = userData:get("commandsUsed")
	local commandData = worker:getCommand(command)
	local commandName = commandData and commandData.name

	if not commandData then
		printf("Could not find command '%s'", command)

		return false
	end

	if commandData.cooldown then
		commandsUsed:set(commandData.origin or commandName, {
			tick = os.time()
		})
	end

	clearTempCommandsUsed(member)
end

return updateCommandCooldown
