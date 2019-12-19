client:on("guildCreate",
	function(guild)
		client:info("New guild available %s (%s)", guild.id, guild.name)

		local guildData = getGuildData(guild)
		local regions = {
			["brazil"] = "pt-br",
			["us"] = "en-us",
		}

		for regionName, regionLang in next, regions do
			local region = guild.region:lower()

			if region:find(regionName) then
				guildData:set("lang", regionLang)
				break
			end
		end
	end
)
