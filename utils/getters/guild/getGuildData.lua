function getGuildData(guild)
	local guild = type(guild) == "string" and client:getGuild(guild) or guild
	local data = think(string.format("./saves/global/%s.bin", guild.id))
	local roles = data:get("roles")
	local mutes = data:get("mutes")

	for property, value in next, config.defaultGuild do
		data:get(property, value)
	end

	for roleId, _ in next, roles:raw() do
		if not getRole(roleId, "id", guild) then
			roles:set(roleId, nil)
		end
	end

	return data
end

return getGuildData
