local _config = {
	name = "roleinfo",
	desc = "${getRoleInfo}",
	usage = "${messageKey}",
	aliases = {"ri"},
	cooldown = 0,
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

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	if data.guild, getRole(args[2], "name", data.guild)) then
		local embed = newEmbed()
		local members = getMembersFromRole(data.guild, getRole(args[2], "name", data.guild))
		local role = getRole(args[2], "name", data.guild)
		local color = role:getColor()

		embed:field({name = localize("${roleName}", guildLang), value = role.name, inline = true})
		embed:field({name = "ID", value = role.id, inline = true})
		embed:field({name = localize("${roleCreatedAt}", guildLang), value = discordia.Date.fromSnowflake(role.id):toISO("T", "Z")})
		embed:field({name = localize("${roleColor}", guildLang), value = role:getColor():toRGB(), inline = true})
		embed:field({name = localize("${roleUsers}", guildLang), value = #role.members:toArray(), inline = true})
		embed:field({name = localize("${roleMentionable}", guildLang), value = role.mentionable, inline = true})
		embed:field({name = localize("${roleHoisted}", guildLang), value = role.hoisted, inline = true})

		bird:post(nil, embed:raw(), data.channel)
	elseif data.guild, getRole(args[2], "id", data.guild)) then
		local embed = newEmbed()
		local members = getMembersFromRole(data.guild, getRole(args[2], "id", data.guild))
		local role = getRole(args[2], "id", data.guild)
		local color = role:getColor()

		embed:field({name = localize("${roleName}", guildLang), value = role.name, inline = true})
		embed:field({name = "ID", value = role.id, inline = true})
		embed:field({name = localize("${roleCreatedAt}", guildLang), value = discordia.Date.fromSnowflake(role.id):toISO("T", "Z")})
		embed:field({name = localize("${roleColor}", guildLang), value = role:getColor():toRGB(), inline = true})
		embed:field({name = localize("${roleUsers}", guildLang), value = #role.members:toArray(), inline = true})
		embed:field({name = localize("${roleMentionable}", guildLang), value = role.mentionable, inline = true})
		embed:field({name = localize("${roleHoisted}", guildLang), value = role.hoisted, inline = true})

		bird:post(nil, embed:raw(), data.channel)
	else
		local text = localize("${roleDoesNotExist}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
	end

	return true
end

return {config = _config, func = _function}
