local _config = {
	name = "setnsfw",
	desc = "${setsNsfwMode}",
	usage = "${valueKey}",
	aliases = {"setsfw"},
	cooldown = 2,
	level = 2,
	direct = false,
	perms = {"manageChannels"}
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	if not args[2] then
		local text = parseFormat("${missingArg}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local bool
	local v = args[2]:lower()

	if isFiltered(v, config.terms.yes) then
		bool = true
	elseif isFiltered(v, config.terms.no) then
		bool = false
	end

	if bool == nil then
		local text = parseFormat("${missingArg}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false
	end

	local guildData = saves.global:get(data.guild.id)
	local valueSet = guildData:set("deleteCommand", bool)

	if valueSet ~= nil then
		local text = parseFormat("${beenDefined}", langList, "deleteCommand", valueSet)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)
		return true
	else
		local text = parseFormat("${noAllowEdit}", langList)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)
		return false
	end
end

return {config = _config, func = _function}
