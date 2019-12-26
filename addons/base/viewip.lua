local _config = {
	name = "viewip",
	desc = "${getsIpData}",
	usage = "${numKey}",
	aliases = {"seeip", "ip"},
	cooldown = 10,
	level = 0,
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

	local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuild)
	local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuild)
	local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuild)

	local decoy
	local firstTime = true
	local searchTerms = data.content:sub(#args[1] + 2):gsub(" ", "+")
	local searchResult = apiSmartIp(searchTerms)
	local list = searchResult

	if list == nil then
		local text = localize("${couldNotFindTerms}", guildLang, searchTerms)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	if searchResult["status-code"] == 200 then
		local geoData = searchResult["geo"]
		if geoData then
			local geoDesc = ""
			geoDesc = localize("%s\n%s **${latitude}:** %s", guildLang, geoDesc, topicEmoji.mentionString, geoData["latitude"] or "-")
			geoDesc = localize("%s\n%s **${longitude}:** %s", guildLang, geoDesc, topicEmoji.mentionString, geoData["longitude"] or "-")
			geoDesc = localize("%s\n%s **${zipCode}:** %s", guildLang, geoDesc, topicEmoji.mentionString, geoData["zip-code"] or "-")
			geoDesc = localize("%s\n%s **${city}:** %s", guildLang, geoDesc, topicEmoji.mentionString, geoData["city"] or "-")
			geoDesc = localize("%s\n%s **${regionCode}:** %s", guildLang, geoDesc, topicEmoji.mentionString, geoData["region-code"] or "-")
			geoDesc = localize("%s\n%s **${regionName}:** %s", guildLang, geoDesc, topicEmoji.mentionString, geoData["region-name"] or "-")
			geoDesc = localize("%s\n%s **${continentCode}:** %s", guildLang, geoDesc, topicEmoji.mentionString, geoData["continent-code"] or "-")
			geoDesc = localize("%s\n%s **${continentName}:** %s", guildLang, geoDesc, topicEmoji.mentionString, geoData["continent-name"] or "-")
			geoDesc = localize("%s\n%s **${capital}:** %s", guildLang, geoDesc, topicEmoji.mentionString, geoData["capital"] or "-")
			geoDesc = localize("%s\n%s **${countryName}:** %s", guildLang, geoDesc, topicEmoji.mentionString, geoData["country-name"] or "-")
			geoDesc = localize("%s\n%s **${countryISOCode}:** %s", guildLang, geoDesc, topicEmoji.mentionString, geoData["country-iso-code"] or "-")
			list[1] = geoDesc
		end

		local asnData = searchResult["asn"]
		if asnData then
			local asnDesc = ""
			asnDesc = localize("%s\n%s **${name}:** %s", guildLang, asnDesc, topicEmoji.mentionString, asnData["name"] or "-")
			asnDesc = localize("%s\n%s **${type}:** %s", guildLang, asnDesc, topicEmoji.mentionString, asnData["type"] or "-")
			asnDesc = localize("%s\n%s **${domain}:** %s", guildLang, asnDesc, topicEmoji.mentionString, asnData["domain"] or "-")
			asnDesc = localize("%s\n%s **${organization}:** %s", guildLang, asnDesc, topicEmoji.mentionString, asnData["organization"] or "-")
			asnDesc = localize("%s\n%s **${asn}:** %s", guildLang, asnDesc, topicEmoji.mentionString, asnData["asn"] or "-")
			list[2] = asnDesc
		end

		local currencyData = searchResult["currency"]
		if currencyDesc then
			local currencyDesc = ""
			currencyDesc = localize("%s\n%s **${nativeName}:** %s", guildLang, currencyDesc, topicEmoji.mentionString, currencyData["native-name"] or "-")
			currencyDesc = localize("%s\n%s **${code}:** %s", guildLang, currencyDesc, topicEmoji.mentionString, currencyData["code"] or "-")
			currencyDesc = localize("%s\n%s **${name}:** %s", guildLang, currencyDesc, topicEmoji.mentionString, currencyData["name"] or "-")
			currencyDesc = localize("%s\n%s **${symbol}:** %s", guildLang, currencyDesc, topicEmoji.mentionString, currencyData["symbol"] or "-")
			list[3] = currencyDesc
		end

		local tzData = searchResult["timezone"]
		if tzDesc then
			local tzDesc = ""
			tzDesc = localize("%s\n%s **${isDaylightSaving}:** %s", guildLang, tzDesc, topicEmoji.mentionString, tzData["is-daylight-saving"] or "-")
			tzDesc = localize("%s\n%s **${gmtOffset}:** %s", guildLang, tzDesc, topicEmoji.mentionString, tzData["gmt-offset"] or "-")
			tzDesc = localize("%s\n%s **${microsoftName}:** %s", guildLang, tzDesc, topicEmoji.mentionString, tzData["microsoft-name"] or "-")
			tzDesc = localize("%s\n%s **${iana}:** %s", guildLang, tzDesc, topicEmoji.mentionString, tzData["iana-name"] or "-")
			list[4] = tzDesc
		end
	end

	local page = 1
	local pages = list and #list or 1

	local function showPage()
		local item = list[page]

		if not item then
			local text = localize("${couldNotFindTerms}", guildLang, searchTerms)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local embed = newEmbed()
		embed:title(localize("${ipInfo} (%s/%s): %s", guildLang, page, pages, searchResult["ip"]))
		embed:description(item)

		embed:color(paint.info)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		if decoy then
			decoy:update(nil, embed:raw())
		else
			decoy = bird:post(nil, embed:raw(), data.channel)
		end

		if firstTime == true then
			firstTime = false
			blinker = blink(decoy:getMessage(), config.timeouts.reaction.value, {data.user.id})

			decoy:addReaction(arwDown)
			decoy:addReaction(arwUp)

			blinker:on(arwDown.id, function()
				page = math.min(pages, page + 1)

				if not private then
					decoy:removeReaction(arwDown, data.user.id)
				end

				showPage()
			end)

			blinker:on(arwUp.id, function()
				page = math.max(1, page - 1)

				if not private then
					decoy:removeReaction(arwUp, data.user.id)
				end

				showPage()
			end)
		end
	end

	showPage()

	return true
end

return {config = _config, func = _function}
