function canRunCommand(data)
	local permit = false
	local private = isPrivateChannel(data.channel)
	local userLevel = not private and getMemberLevel(data.user, data.guild) or 0
	local commandPatron = false
	local commandName = data.command:lower():sub(2)
	local commandData = commandName and commands.list[commandName]
	local commandLevel = commandData and commandData.level

	if not (userLevel and commandData and data) then
		return false, printf("Missing arguments on canRunCommand()")
	end

	local member = data.user
	local patron = data.member and isPatron(data.member) or (userLevel >= 255)

	if userLevel then
		if commandData.level then
			if type(commandData.level) == "number" and userLevel >= commandData.level then
				if commandData.patron then
					commandPatron = true

					if private then
						if commandData.allowDm then
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
						if commandData.allowDm then
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
					if commandData.allowDm then
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
					if commandData.allowDm then
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
