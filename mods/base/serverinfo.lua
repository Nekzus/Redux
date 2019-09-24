local name = "serverinfo"
local desc = "${returnsServerInfo}"
local usage = ""
local aliases = {"svinfo", "sinfo", "ginfo", "guildinfo"}

local cd = 10
local level = 0
local allowDm = false

local func = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local member = data.member
	local voice = member.voiceChannel

	if not voice then
		local text = parseFormat("${mustBeInGuildVoice}", langList)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local embed = replyEmbed(text, data.message, "info")
	local screenLink = apis.misc:screenShare(data.guild.id, voice.id)

	local embed = newEmbed()

	embed:title(parseFormat("${shareLinkForVoice}", langList, voice.name))
	embed:description(parseFormat("[${clickHereScreenshare}](%s)", langList, screenLink))

	embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
	embed:footerIcon(config.images.info)
	signFooter(embed, data.author, guildLang)

	bird:post(nil, embed:raw(), data.channel)

	return true
end

-- Command constructor
commands:create({
	name = name,
	desc = desc,
	usage = usage,
	allowDm = allowDm,
	cd = cd,
	func = func,
}):accept(#aliases > 0 and unpack(aliases))
