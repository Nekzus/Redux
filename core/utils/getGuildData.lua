function getGuildData(guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local guildData = saves.global:get(guild.id)
	local guildRoles = guildData:get("roles")
	local guildMutes = guildData:get("mutes")

	for k, v in next, config.default do
		guildData:get(k, v)
	end

	for roleId, _ in next, guildRoles:raw() do
		if not getRole(roleId, "id", guild) then
			guildRoles:set(roleId, nil)
		end
	end

	return guildData
end

return getGuildData
