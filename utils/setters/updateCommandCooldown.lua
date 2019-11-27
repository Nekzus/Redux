function updateCommandCooldown(command, member)
	local temp = getTempData()
	local usersData = temp:get("users")
	local userData = usersData:get(member.id)
	local commandsUsed = userData:get("commandsUsed")
	local commandData = commands.list[command]

	if not commandData then
		printf("Could not find command '%s'", command)

		return false
	end

	if commandData.cooldown then
		commandsUsed:set(commandData.origin or command, {
			lastUse = os.time()
		})
	end

	clearTempCommandsUsed(member)
end

return updateCommandCooldown
