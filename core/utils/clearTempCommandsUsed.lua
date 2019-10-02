function clearTempCommandsUsed(member)
	local usersData = saves.temp:get("users")
	local userData = usersData:get(member.id)
	local commandsUsed = userData:get("commandsUsed")

	for k, v in next, commandsUsed:raw() do
		if canUseCommand(k, member) then
			commandsUsed:set(k, nil)
		end
	end
end

return clearTempCommandsUsed
