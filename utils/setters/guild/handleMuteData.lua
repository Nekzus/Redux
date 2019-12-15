function handleMuteData(muteData)
	muteTimers = muteTimers or {}

	if not muteData.guild then
		print("Guild for muteData not found")
		return false
	end

	local guild = client:getGuild(muteData.guild)
	local guildData = getGuildData(guild)
	local tempMutes = saves.temp:get("mutes")
	local userId = muteData.userId
	local member = guild:getMember(userId)

	if not member then
		guildData:get("mutes"):set(userId, nil)

		if muteData.guid then
			tempMutes:set(muteData.guid, nil)
		end
	end

	local newTime = os.time()
	local elapsedTime = newTime - muteData.added
	local roleId = getPrimaryRoleIndex(-1, guildData:get("roles"):raw())
	local role = roleId and getRole(roleId, "id", guild)

	if not role then
		guildData:get("mutes"):set(member.id, nil)
		return false
	end

	if elapsedTime >= muteData.duration then
		guildData:get("mutes"):set(member.id, nil)
		tempMutes:set(muteData.guid, nil)

		if role and member:hasRole(roleId) then
			member:removeRole(role)
		end

		return true
	end

	-- :stop() :close()
	local process = timer.setTimeout((muteData.duration - elapsedTime) * 1000, function()
		coroutine.wrap(function()
			guildData:get("mutes"):set(member.id, nil)
			tempMutes:set(muteData.guid, nil)

			if role and member:hasRole(roleId) then
				member:removeRole(role)
			end
		end)()
	end)

	muteTimers[muteData.guid] = process

	return process
end

return handleMuteData
