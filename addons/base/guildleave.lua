local _config = {
	name = "guildleave",
	desc = "${leavesMentionedGuild}",
	usage = "${numKey}",
	aliases = {"gleave", "gl"},
	cooldown = 0,
	level = 5,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
		local args = data.args

	if not (args[2] or #args[2] ~= 18) then
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local decoy = bird:post(getLoadingEmoji(), nil, data.channel)
	local mentionedGuild = client:getGuild(args[2])

	if not mentionedGuild then
		local text = localize("${guildNotFound}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	else
		local guildName = mentionedGuild.name
		local text = localize("${successLeftGuild}", guildLang, guildName)
		local embed = replyEmbed(text, data.message, "ok")

		mentionedGuild:leave()
		decoy:update(nil, embed:raw())

		return true
	end
end

return {config = _config, func = _function}
