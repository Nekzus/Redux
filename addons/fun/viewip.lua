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
		local geoData = searchResult["geo"]
		local geoDesc = ""
		geoDesc = parseFormat("%s\n${latitude}: %s", langData, geoDesc, geoData["latitude"])
		geoDesc = parseFormat("%s\n${longitude}: %s", langData, geoDesc, geoData["longitude"])
		geoDesc = parseFormat("%s\n${zipCode}: %s", langData, geoDesc, geoData["zip-code"])
		geoDesc = parseFormat("%s\n${city}: %s", langData, geoDesc, geoData["city"])
		geoDesc = parseFormat("%s\n${regionCode}: %s", langData, geoDesc, geoData["region-code"])
		geoDesc = parseFormat("%s\n${regionName}: %s", langData, geoDesc, geoData["region-name"])
		geoDesc = parseFormat("%s\n${continentCode}: %s", langData, geoDesc, geoData["continent-code"])
		geoDesc = parseFormat("%s\n${continentName}: %s", langData, geoDesc, geoData["continent-name"])
		geoDesc = parseFormat("%s\n${capital}: %s", langData, geoDesc, geoData["capital"])
		geoDesc = parseFormat("%s\n${countryName}: %s", langData, geoDesc, geoData["country-name"])
		geoDesc = parseFormat("%s\n${countryISOCode}: %s", langData, geoDesc, geoData["country-iso-code"])
		insert(list, geoDesc)

		local asnData = searchResult["asn"]
		local asnDesc = ""
		asnDesc = parseFormat("%s\n${name}: %s", langData, asnDesc, asnData["name"])
		asnDesc = parseFormat("%s\n${type}: %s", langData, asnDesc, asnData["type"])
		asnDesc = parseFormat("%s\n${domain}: %s", langData, asnDesc, asnData["domain"])
		asnDesc = parseFormat("%s\n${organization}: %s", langData, asnDesc, asnData["organization"])
		asnDesc = parseFormat("%s\n${asn}: %s", langData, asnDesc, asnData["asn"])
		insert(list, asnDesc)

		local currencyData = searchResult["currency"]
		local currencyDesc = ""
		currencyDesc = parseFormat("%s\n${nativeName}: %s", langData, currencyDesc, currencyData["native-name"])
		currencyDesc = parseFormat("%s\n${code}: %s", langData, currencyDesc, currencyData["code"])
		currencyDesc = parseFormat("%s\n${name}: %s", langData, currencyDesc, currencyData["name"])
		currencyDesc = parseFormat("%s\n${symbol}: %s", langData, currencyDesc, currencyData["symbol"])
		insert(list, currencyDesc)

		local tzData = searchResult["timezone"]
		local tzDesc = ""
		tzDesc = parseFormat("%s\n${isDaylightSaving}: %s", langData, tzDesc, tzData["is-daylight-saving"])
		tzDesc = parseFormat("%s\n${gmtOffset}: %s", langData, tzDesc, tzData["gmt-offset"])
		tzDesc = parseFormat("%s\n${microsoftName}: %s", langData, tzDesc, tzData["microsoft-name"])
		tzDesc = parseFormat("%s\n${iana}: %s", langData, tzDesc, tzData["iana-name"])
		insert(list, tzDesc)
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
		embed:title(parseFormat("${ipInfo}: %s", langData, searchResult["ip"]))
		embed:description(item)

		embed:color(config.colors.blue)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

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
