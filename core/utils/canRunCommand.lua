function canRunCommand(data)
	local private = isPrivateChannel(data.channel)
	local commandPatron = false
	local commandPrefix = data.prefix
	local commandName = data.command:lower():sub(#commandPrefix + 1)
	local commandData = commandName and commands.list[commandName]
	local commandLevel = commandData and commandData.level
	local userLevel = not private and getMemberLevel(data.user, data.guild) or 0

	if data.user.id == config.meta.ownerId then
		userLevel = 5
	end

	if not (userLevel and commandData and data) then
		print("Missing arguments on canRunCommand()")

		return false
	end

	local member = data.user
	local patron = data.member and isPatron(data.member) or (userLevel == 5)
	local permit = false

	if userLevel then
		if commandData.level then
			if type(commandData.level) == "number" and userLevel >= commandData.level then
				if commandData.patron then
					commandPatron = true

					if private then
						if commandData.direct then
							if patron then
								permit = true
							end
						end
					else
						if patron then
							permit = true
						end
					end
				else
					if private then
						if commandData.direct then
							permit = true
						end
					else
						permit = true
					end
				end
			end
		else
			if commandData.patron then
				commandPatron = true

				if private then
					if commandData.direct then
						if patron then
							permit = true
						end
					end
				else
					if patron then
						permit = true
					end
				end
			else
				if private then
					if commandData.direct then
						permit = true
					end
				else
					permit = true
				end
			end
		end
	end

	return permit, commandPatron
end

return canRunCommand
