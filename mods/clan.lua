--[[local category = "${clans}"




commands:create({name = "clan",
	desc = "--",
	usage = "--",

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args


	end
})
]]
