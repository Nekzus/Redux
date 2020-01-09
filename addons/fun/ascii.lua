local _config = {
	name = "ascii",
	desc = "${createsAsciiText}",
	usage = "${messageKey}",
	aliases = {},
	cooldown = 5,
	level = 0,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	

	return true
end

return {config = _config, func = _function}
