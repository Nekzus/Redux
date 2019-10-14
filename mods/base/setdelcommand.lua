local _config = {
	name = "setdelcmd",
	desc = "${setsDelCmd}",
	usage = "${valueKey}",
	aliases = {},
	cooldown = 0,
	level = 3,
	direct = false,
	perms = {"manageMessages"}
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

	local yesList = {
		"on",
		"true",
		"1",
		"+"
	}

	local noList = {
		"off",
		"false",
		"0",
		"-"
	}

	if isFiltered(v, yesList) then
		bool = true
	elseif isFiltered(v, noList) then
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
