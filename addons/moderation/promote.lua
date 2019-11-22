local _config = {
	name = "promote",
	desc = "${promotesUser}",
	usage = "${userKey}",
	aliases = {"pro", "prom"},
	cooldown = 0,
	level = 5, -- 2
	direct = false,
	perms = {"manageRoles"},
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	if not specifiesUser(data.message) then
		local text = localize("${specifyUser}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false
	elseif mentionsOwner(data.message) then
		local text = localize("${noExecuteOwner}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false
	elseif mentionsBot(data.message) then
		local text = localize("${noExecuteBot}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false
	elseif mentionsSelf(data.message) then
		local text = localize("${noExecuteSelf}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false
	end

	local user = data.message.mentionedUsers.first
	local member = user and data.guild:getMember(user)

	if not member then
		local text = localize("${userNotFound}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local author = data.member

	if member.highestRole.position >= data.guild.me.highestRole.position
	or member.highestRole.position >= author.highestRole.position then
		local text = localize("${mentionedHigher}", guildLang)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local userRoles = getUserDefinedRoles(member, data.guild)
	local guildRoles = guildData:get("roles"):raw()
	local userRole = userRoles[1]

	-- Caso o usuário já tiver um cargo, teremos que subir ele de nível
	if userRole then
		local result = {}

		-- Procura por um cargo do mesmo nível com um index superior
		for _, roleData in next, guildRoles do
			if roleData.level == userRole.level then
				insert(result, roleData)
			end
		end

		if #result == 0 then

		end

		sort(result, function(a, b)
			return a.level > b.level or (a.level == b.level and a.added > b.added)
		end)

		local roleData = result[1]
	end
end

return {config = _config, func = _function}
