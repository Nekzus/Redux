local _config = {
	name = "roleinfo",
	desc = "${getRoleInfo}",
	usage = "${messageKey}",
	aliases = {"rinfo"},
	cooldown = 3,
	level = 5,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	if not (args[2]) then
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		data.channel:send{embed = embed:raw()}

		return false
	end

	if getRole(args[2], "name", data.guild) then
		local embed = newEmbed()
		local role = getRole(args[2], "name", data.guild)

		embed:field({name = localize("${roleName}", guildLang), value = role.name, inline = true})
		embed:field({name = "ID", value = role.id, inline = true})
		embed:field({name = localize("${roleUsers}", guildLang), value = #role.members:toArray(), inline = true})
		embed:field({name = localize("${roleCreatedAt}", guildLang), value = discordia.Date.fromSnowflake(role.id):toISO("T", "Z"), inline = true})
		embed:field({name = localize("${roleColor}", guildLang), value = format("%s, %s, %s", role:getColor():toRGB()), inline = true})
		embed:field({name = localize("${roleMentionable}", guildLang), value = role.mentionable, inline = true})
		embed:field({name = localize("${roleHoisted}", guildLang), value = role.hoisted, inline = true})

		data.channel:send{embed = embed:raw()}
	elseif getRole(args[2], "id", data.guild) then
		local embed = newEmbed()
		local role = getRole(args[2], "id", data.guild)

		embed:field({name = localize("${roleName}", guildLang), value = role.name, inline = true})
		embed:field({name = "ID", value = role.id, inline = true})
		embed:field({name = localize("${roleUsers}", guildLang), value = #role.members:toArray(), inline = true})
		embed:field({name = localize("${roleCreatedAt}", guildLang), value = discordia.Date.fromSnowflake(role.id):toISO("T", "Z"), inline = true})
		embed:field({name = localize("${roleColor}", guildLang), value = format("%s, %s, %s", role:getColor():toRGB()), inline = true})
		embed:field({name = localize("${roleMentionable}", guildLang), value = role.mentionable, inline = true})
		embed:field({name = localize("${roleHoisted}", guildLang), value = role.hoisted, inline = true})

		data.channel:send{embed = embed:raw()}
	else
		local text = localize("${roleDoesNotExist}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
	end

	return true
end

return {config = _config, func = _function}
