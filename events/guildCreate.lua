--[[
	Parte responsável por cuidar de eventos referentes à novas guildas
	sendo disponibilizadas ao bot
]]

client:on("guildCreate",
	function(guild)
		printf("New guild is now available %s (%s)", guild.id, guild.name)

		local guildData = getGuildData(guild)
		local regions = {
			["brazil"] = "pt-br",
			["us"] = "en-us",
		}

		-- Verifica se uma guilda já está alocada dentre alguma das regiões
		-- pré-definidas na lista, caso sim, o bot irá ajustar a linguage
		-- local automaticamente
		for regionName, regionLang in next, regions do
			local region = guild.region:lower()

			if region:find(regionName) then
				guildData:set("lang", regionLang)
				break
			end
		end
	end
)
