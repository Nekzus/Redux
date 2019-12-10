local _config = {
	name = "lua",
	desc = "${allowsLua}",
	usage = "${codeKey}",
	aliases = {"run", "f"},
	cooldown = 0,
	level = 5,
	direct = true,
}

function setExecutionContext(userId, level)
	if inList(userId, config.main.ownerList) then
		executionContext = level or "user"
	end
end

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	if not (args[2]) then
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local level = inList(data.author.id, config.main.ownerList) and "dev" or "user"
	local success, response = loadCode(
		data.content:sub(#args[1] + 2),
		level,
		{
			os = os,
			data = data,
		}
	)

	bird:post(response, nil, data.channel)

	return true
end

return {config = _config, func = _function}
