function clearTempCommandsUsed(member)
	local usersData = saves.temp:get("users")
	local userData = usersData:get(member.id)
	local commandsUsed = userData:get("commandsUsed")

	for command, _ in next, commandsUsed:raw() do
		local canUse = canUseCommand(command, member)

		if canUse == true or canUse == nil then
			commandsUsed:set(command, nil)
		end
	end
end

return clearTempCommandsUsed
