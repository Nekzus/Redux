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
	local args = data.args

	if not (args[2]) then
		local text = localize("${missingArg}", guildLang)
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

	if searchResult == nil or searchResult.list == nil then
		local text = localize("${couldNotFindTerms}", guildLang, searchTerms)
		local embed = replyEmbed(text, data.message, "warn")

		decoyBird:update(nil, embed:raw())

		return false
	end

	if searchResult["status-code"] == 200 then
		local geoData = searchResult["geo"]
		local geoDesc = ""
		geoDesc = localize("%s\n${latitude}: %s", guildLang, geoDesc, geoData["latitude"])
		geoDesc = localize("%s\n${longitude}: %s", guildLang, geoDesc, geoData["longitude"])
		geoDesc = localize("%s\n${zipCode}: %s", guildLang, geoDesc, geoData["zip-code"])
		geoDesc = localize("%s\n${city}: %s", guildLang, geoDesc, geoData["city"])
		geoDesc = localize("%s\n${regionCode}: %s", guildLang, geoDesc, geoData["region-code"])
		geoDesc = localize("%s\n${regionName}: %s", guildLang, geoDesc, geoData["region-name"])
		geoDesc = localize("%s\n${continentCode}: %s", guildLang, geoDesc, geoData["continent-code"])
		geoDesc = localize("%s\n${continentName}: %s", guildLang, geoDesc, geoData["continent-name"])
		geoDesc = localize("%s\n${capital}: %s", guildLang, geoDesc, geoData["capital"])
		geoDesc = localize("%s\n${countryName}: %s", guildLang, geoDesc, geoData["country-name"])
		geoDesc = localize("%s\n${countryISOCode}: %s", guildLang, geoDesc, geoData["country-iso-code"])
		list[1] = geoDesc

		local asnData = searchResult["asn"]
		local asnDesc = ""
		asnDesc = localize("%s\n${name}: %s", guildLang, asnDesc, asnData["name"])
		asnDesc = localize("%s\n${type}: %s", guildLang, asnDesc, asnData["type"])
		asnDesc = localize("%s\n${domain}: %s", guildLang, asnDesc, asnData["domain"])
		asnDesc = localize("%s\n${organization}: %s", guildLang, asnDesc, asnData["organization"])
		asnDesc = localize("%s\n${asn}: %s", guildLang, asnDesc, asnData["asn"])
		list[2] = asnDesc

		local currencyData = searchResult["currency"]
		local currencyDesc = ""
		currencyDesc = localize("%s\n${nativeName}: %s", guildLang, currencyDesc, currencyData["native-name"])
		currencyDesc = localize("%s\n${code}: %s", guildLang, currencyDesc, currencyData["code"])
		currencyDesc = localize("%s\n${name}: %s", guildLang, currencyDesc, currencyData["name"])
		currencyDesc = localize("%s\n${symbol}: %s", guildLang, currencyDesc, currencyData["symbol"])
		list[3] = currencyDesc

		local tzData = searchResult["timezone"]
		local tzDesc = ""
		tzDesc = localize("%s\n${isDaylightSaving}: %s", guildLang, tzDesc, tzData["is-daylight-saving"])
		tzDesc = localize("%s\n${gmtOffset}: %s", guildLang, tzDesc, tzData["gmt-offset"])
		tzDesc = localize("%s\n${microsoftName}: %s", guildLang, tzDesc, tzData["microsoft-name"])
		tzDesc = localize("%s\n${iana}: %s", guildLang, tzDesc, tzData["iana-name"])
		list[4] = tzDesc
	end

	local page = 1
	local pages = list and #list or 1

	local function showPage()
		local item = list[page]

		if not item then
			local text = localize("${couldNotFindTerms}", guildLang, searchTerms)
			local embed = replyEmbed(text, data.message, "error")

			decoyBird:update(nil, embed:raw())

			return false
		end

		local embed = newEmbed()
		embed:title(localize("${ipInfo}: %s", guildLang, searchResult["ip"]))
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
