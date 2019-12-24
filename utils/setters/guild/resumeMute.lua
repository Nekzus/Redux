function resumeMute(guid)
	local tempMutes = saves.temp:get("mutes")
	local tempData = tempMutes and tempMutes:raw()[guid]

	if not tempData then
		return false
	end

	local userId = tempData.userId
	local guildId = tempData.guildId

	local guildData = guildId and getGuildData(guildId)
	local guildMutes = guildData and guildData:get("mutes")
	local guildMute = guildMutes and guildMutes:raw()[userId]

	if not guildMute then
		client:error("Could not find guildMute in resumeMute, clearing stored data")
		tempMutes:set(guid, nil)
		saves.temp:save()
		return false
	end

	local guild = client:getGuild(guildId)
	local member = guild and guild:getMember(guildMute.userId)

	if not guild then
		client:error("Could not find guild in resumeMute, clearing stored data")
		tempMutes:set(guid, nil)
		saves.temp:save()
		return false
	end

	local elapsedTime = os.time() - guildMute.tick
	local roleId = getPrimaryRoleIndex(-1, guildData:get("roles"):raw())
	local role = roleId and getRole(roleId, "id", guild)

	if not role then
		tempMutes:set(guid, nil)
		guildMutes:set(userId, nil)
		saves.temp:save()
		guildData:save()
		return false
	end

	if elapsedTime >= guildMute.duration then
		tempMutes:set(guid, nil)
		guildMutes:set(userId, nil)
		saves.temp:save()
		guildData:save()

		if member:hasRole(role) then
			member:removeRole(role)
		end

		return true
	end

	local process = bot.muteTimers[guid]

	if process then
		if not process:is_closing() then
			process:close()
			process = nil
		end
	end

	process = timer.setTimeout((guildMute.duration - elapsedTime) * 1000, function()
		coroutine.wrap(function()
			tempMutes:set(guid, nil)
			guildMutes:set(userId, nil)
			saves.temp:save()
			guildData:save()

			role = getRole(roleId, "id", guild)

			if role and member:hasRole(role) then
				member:removeRole(role)
			end
		end)()
	end)

	bot.muteTimers[guid] = process

	return process
end

return resumeMute
