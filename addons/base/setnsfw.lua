local _config = {
	name = "setnsfw",
	desc = "${setsNsfwMode}",
	usage = "${valueKey}",
	aliases = {"nsfw"},
	cooldown = 2,
	level = 2,
	direct = false,
	perms = {"manageChannels"}
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	if not args[2] then
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local bool
	local v = args[2]:lower()

	if inList(v, config.terms.yes) then
		bool = true
	elseif inList(v, config.terms.no) then
		bool = false
	end

	if bool == nil then
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false
	end

	local channel = data.channel
	local success

	if bool == true and channel.nsfw == false then
		success = data.channel:enableNSFW()
	elseif bool == false and channel.nsfw == true then
		success = data.channel:disableNSFW()
	end

	if success then
		local text = localize("${beenDefined}", guildLang, "NSFW", success)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)
		return true
	else
		local text = localize("${noAllowEdit}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false
	end
end

return {config = _config, func = _function}
