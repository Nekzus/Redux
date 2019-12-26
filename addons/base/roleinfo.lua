local _config = {
	name = "roleinfo",
	desc = "${getRoleInfo}",
	usage = "${messageKey}",
	aliases = {"rinfo"},
	cooldown = 3,
	level = 0,
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

	local text = data.content:sub(#args[1] + 2)
	local role = getRole(text, "name", data.guild) or getRole(text, "id", data.guild)

	if role then
		local embed = enrich()

		embed:field({name = localize("${roleName}", guildLang), value = role.name, inline = true})
		embed:field({name = localize("${id}", guildLang), value = role.id, inline = true})
		embed:field({name = localize("${roleUsers}", guildLang), value = #role.members:toArray(), inline = true})
		embed:field({name = localize("${roleCreatedAt}", guildLang), value = discordia.Date.fromSnowflake(role.id):toString("%m/%d/%Y %I:%M %p"), inline = true})
		embed:field({name = localize("${roleColor}", guildLang), value = role:getColor():toHex(), inline = true})
		embed:field({name = localize("${roleMentionable}", guildLang), value = role.mentionable, inline = true})
		embed:field({name = localize("${roleHoisted}", guildLang), value = role.hoisted, inline = true})
		embed:color({role:getColor():toRGB()}) --paint.info
		--embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		data.channel:send{embed = embed:raw()}
	else
		local text = localize("${roleDoesNotExist}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
	end

	return true
end

return {config = _config, func = _function}
