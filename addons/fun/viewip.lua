local _config = {
	name = "viewip",
	desc = "${getsIpData}",
	usage = "${numKey}",
	aliases = {"seeip", "ip"},
	cooldown = 10,
	level = 5,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langData = langs[guildLang]
	local args = data.args

	if not (args[2]) then
		local text = parseFormat("${missingArg}", langData)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuild)
	local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuild)

	local firstTime = true
	local decoyBird = bird:post(getLoadingEmoji(), nil, data.channel)
	local searchTerms = data.content:sub(#args[1] + 2):gsub(" ", "+")
	local searchResult = apiSmartIp(searchTerms)
	local list = {}

	if searchResult["status-code"] == 200 then
		local geoEmbed = newEmbed()
		geoEmbed:title(parseFormat("${geo}", langData))

		local geoData = searchResult["geo"]
		local geoDesc = ""
		geoDesc = format("%s\n%s: %s", geoDesc, parseFormat("${isMetric}", langData), geoData["is-metric"])
		geoDesc = format("%s\n%s: %s", geoDesc, parseFormat("${isInEurope}", langData), geoData["is-in-europe"])
		geoDesc = format("%s\n%s: %s", geoDesc, parseFormat("${latitude}", langData), geoData["latitude"])
		geoDesc = format("%s\n%s: %s", geoDesc, parseFormat("${zipCode}", langData), geoData["zip-code"])
		geoDesc = format("%s\n%s: %s", geoDesc, parseFormat("${city}", langData), geoData["city"])
		geoDesc = format("%s\n%s: %s", geoDesc, parseFormat("${regionCode}", langData), geoData["region-code"])
		geoDesc = format("%s\n%s: %s", geoDesc, parseFormat("${regionName}", langData), geoData["region-name"])
		geoDesc = format("%s\n%s: %s", geoDesc, parseFormat("${continentCode}", langData), geoData["continent-code"])
		geoDesc = format("%s\n%s: %s", geoDesc, parseFormat("${continentName}", langData), geoData["continent-code"])
		geoDesc = format("%s\n%s: %s", geoDesc, parseFormat("${capital}", langData), geoData["capital"])
		geoDesc = format("%s\n%s: %s", geoDesc, parseFormat("${countryName}", langData), geoData["country-name"])
		geoDesc = format("%s\n%s: %s", geoDesc, parseFormat("${countryISOCode}", langData), geoData["country-iso-code"])

		geoEmbed:description(geoDesc)
		insert(list, geoEmbed)

		local countryEmbed = newEmbed()
		countryEmbed:title(parseFormat("${country}", langData))

		local countryData = searchResult["country"]
		local countryDesc = ""
		countryDesc = format("%s\n%s: %s", countryDesc, parseFormat("${isMetric}", langData), countryData["is-metric"])
		countryDesc = format("%s\n%s: %s", countryDesc, parseFormat("${isInEurope}", langData), countryData["is-in-europe"])
		countryDesc = format("%s\n%s: %s", countryDesc, parseFormat("${regionGeoId}", langData), countryData["region-geo-id"])
		countryDesc = format("%s\n%s: %s", countryDesc, parseFormat("${continentGeoId}", langData), countryData["continent-geo-id"])
		countryDesc = format("%s\n%s: %s", countryDesc, parseFormat("${countryGeoId}", langData), countryData["country-geo-id"])
		countryDesc = format("%s\n%s: %s", countryDesc, parseFormat("${regionCode}", langData), countryData["region-code"])
		countryDesc = format("%s\n%s: %s", countryDesc, parseFormat("${regionName}", langData), countryData["region-name"])
		countryDesc = format("%s\n%s: %s", countryDesc, parseFormat("${continentCode}", langData), countryData["continent-code"])
		countryDesc = format("%s\n%s: %s", countryDesc, parseFormat("${continentName}", langData), countryData["continent-name"])
		countryDesc = format("%s\n%s: %s", countryDesc, parseFormat("${capital}", langData), countryData["capital"])
		countryDesc = format("%s\n%s: %s", countryDesc, parseFormat("${countryName}", langData), countryData["country-name"])
		countryDesc = format("%s\n%s: %s", countryDesc, parseFormat("${countryTwoLetterISOCode}", langData), countryData["country-two-letter-iso-code"])
		countryDesc = format("%s\n%s: %s", countryDesc, parseFormat("${countryISOCode}", langData), countryData["country-iso-code"])

		countryEmbed:description(countryDesc)
		insert(list, countryData)

		local locationEmbed = newEmbed()
		locationEmbed:title(parseFormat("${location}", langData))

		locationData = searchResult["location"]
		locationDesc = ""
		locationDesc = format("%s\n%s: %s", locationDesc, parseFormat("${isMetric}", langData), countryData["is-metric"])

		-- https://api.smartip.io/201.16.189.129?api_key=e4e5b09e-8550-4ac3-a1ec-9111e95b3886
	end

	local page = 1
	local pages = list and #list or 1

	if searchResult == nil or searchResult.list == nil then
		local text = parseFormat("${couldNotFindTerms}", langData, searchTerms)
		local embed = replyEmbed(text, data.message, "warn")

		decoyBird:update(nil, embed:raw())

		return false
	end

	local function showPage()
		local item = list[page]

		if not item then
			local text = parseFormat("${couldNotFindTerms}", langData, searchTerms)
			local embed = replyEmbed(text, data.message, "error")

			decoyBird:update(nil, embed:raw())

			return false
		end

		local embed = newEmbed()
		embed:author(parseFormat("${urbanDictionary}"))
		embed:authorImage(config.images.urbanDictionary)
		embed:authorUrl(item.permalink)

		embed:field({
			name = item.word,
			value = item.definition,
			inline = true,
		})
		embed:field({
			name = parseFormat("${example}", langData),
			value = item.example,
			inline = true,
		})
		embed:field({
			name = parseFormat("${rating}", langData),
			value = format("%s %s\n%s %s", ":+1:", item.thumbs_up, ":-1:", item.thumbs_down),
			inline = true,
		})

		decoyBird:update(nil, embed:raw())

		if firstTime == true then
			firstTime = false
			blinker = blink(decoyBird:getMessage(), config.timeouts.reaction, {data.user.id})

			decoyBird:addReaction(arwDown)
			decoyBird:addReaction(arwUp)

			blinker:on(arwDown.id, function()
				page = min(pages, page + 1)

				if not private then
					decoyBird:removeReaction(arwDown, data.user.id)
				end

				showPage()
			end)

			blinker:on(arwUp.id, function()
				page = max(1, page - 1)

				if not private then
					decoyBird:removeReaction(arwUp, data.user.id)
				end

				showPage()
			end)
		end
	end

	showPage()

	return true
end

return {config = _config, func = _function}
