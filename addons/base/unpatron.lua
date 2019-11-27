local _config = {
	name = "unpatron",
	desc = "${addsPatron}",
	usage = "${userKey}",
	aliases = {"unpat", "upat"},
	cooldown = 0,
	level = 5,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langData = langs[guildLang]
	local args = data.args

	local user = data.message.mentionedUsers.first

	if not user then
		local text = parseFormat("${userNotFound}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return true
	end

	local member = data.guild:getMember(user)

	if not data.message.mentionedUsers.first
	or not data.guild:getMember(user) then
		local text = parseFormat("${userNotFound}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return true
	end

	local track = getTrackData()
	local patrons = track:get("patrons")

	if not patrons:raw()[member.id] then
		local text = parseFormat("${notPatron}", langData, member.tag)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return true
	else
		local text = parseFormat("${patronRemoved}", langData, member.tag)
		local embed = replyEmbed(text, data.message, "ok")

		patrons:set(tostring(member.id), nil)
		track:close()
		bird:post(nil, embed:raw(), data.channel)

		return true
	end
end

return {config = _config, func = _function}
