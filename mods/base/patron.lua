local _config = {
	name = "patron",
	desc = "${addsPatron}",
	usage = "${userKey}",
	aliases = {"pat"},
	cooldown = 0,
	level = 5,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local user = data.message.mentionedUsers.first

	if not user then
		local text = parseFormat("${userNotFound}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local member = data.guild:getMember(user)

	if not data.message.mentionedUsers.first
	or not data.guild:getMember(user) then
		local text = parseFormat("${userNotFound}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local patrons = saves.track:get("patrons")
	local patronData = patrons:raw()[member.id]
	local numLevel = tonumber(args[3])
	local updated = false

	if patronData then
		if numLevel == nil or patronData.level == numLevel then
			local text = parseFormat("${alreadyPatron}", langList, member.tag)
			local embed = replyEmbed(text, data.message, "warn")

			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			updated = true
		end
	end

	local text = updated and parseFormat("${patronLevelSet}", langList, member.tag, numLevel or 1)
	or parseFormat("${patronAdded}", langList, member.tag)
	local embed = replyEmbed(text, data.message, "ok")

	patrons:set(tostring(member.id), {level = numLevel or 1, added = os.time()})
	db.save(saves.track.bin, "track")
	bird:post(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
