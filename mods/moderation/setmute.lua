local _config = {
	name = "setmute",
	desc = "${addsRoleMuted}",
	usage = "${nameKey}",
	aliases = {"smute"},
	cooldown = 0,
	level = 3,
	direct = false,
	perms = {"manageChannels", "manageRoles"},
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local roleName = data.content:sub(#data.args[1] + 2)
	local guild = data.guild
	local role = getRole(roleName, "name", data.guild)
	local level = -1

	if role then
		local text = parseFormat("${roleAddedMuted}", langList, roleName)
		local embed = replyEmbed(text, data.message, "ok")
		local perms = {level = level, added = os.time()}
		local enum = enums.permission

		-- Configura o cargo para não ter permissões relevantes
		role:denyPermissions(
			enum.sendMessages,
			enum.addReactions,
			enum.manageMessages,
			enum.createInstantInvite
		)

		-- Configura o cargo para não ter permissões em todos os canais
		-- Isso faz com que não seja necessário remover os de mais cargos do usuário
		local channels = guild.textChannels:toArray()

		for _, channel in next, channels do
			local rolePerm = channel:getPermissionOverwriteFor(role)

			rolePerm:denyPermissions(
				enum.sendMessages,
				enum.addReactions,
				enum.manageMessages,
				enum.createInstantInvite
			)
		end

		-- Configura o cargo na lista de cargos da guilda
		guildData:get("roles"):set(role.id, perms)
		bird:post(nil, embed:raw(), data.channel)

		return true
	else
		local text = parseFormat("${roleNotFound}", langList, roleName)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false
	end
end

return {config = _config, func = _function}
