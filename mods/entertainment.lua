local category = "${entertainment}"

math.randomseed(os.time())

commands:create({name = "cat",
	desc = "${showCat}",
	usage = "",
	allowDm = true,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local result, err = apis.misc:cat()
		local embed = newEmbed()

		signFooter(embed, data.author, guildLang)

		if result then
			embed:image(result)
			embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
			embed:footerIcon(config.images.info)

			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			embed:description(parseFormat("${couldNotProcess}", langList))
			embed:color(config.colors.red:match(config.patterns.colorRGB.capture))
			embed:footerIcon(config.images.error)

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end
})

commands:create({name = "dog",
	desc = "${showDog}",
	usage = "",
	allowDm = true,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local result, err = apis.misc:dog()
		local embed = newEmbed()

		signFooter(embed, data.author, guildLang)

		if result then
			embed:image(result)
			embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
			embed:footerIcon(config.images.info)

			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			embed:description(parseFormat("${couldNotProcess}", langList))
			embed:color(config.colors.red:match(config.patterns.colorRGB.capture))
			embed:footerIcon(config.images.error)

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end
})

commands:create({name = "8ball",
	desc = "${answersYesNoMaybe}",
	usage = "<-y|-n|-m> ${messageKey}",
	allowDm = true,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local decoy = bird:post(getLoadingEmoji(), nil, data.channel)
		local embed = newEmbed()
		local question = data.content:sub(#args[1] + 2) or "-"
		local resultText, resultImage = apis.misc:yesno(data.message.content) --forceYNM)

		question:gsub("`", "")
		question:gsub("*", "")
		question:gsub("__", "")
		question:gsub("~", "")

		signFooter(embed, data.author, guildLang)

		if resultText then
			if resultText then
				embed:field({
					name = parseFormat("${question}", langList),
					value = format("```%s```", question),
					inline = true,
				})
				embed:field({
					name = parseFormat("${answer}", langList),
					value = format("```%s```", (resultText == "yes" and parseFormat("${yes}", langList)
						or resultText == "no" and parseFormat("${no}", langList)
					or resultText == "maybe" and parseFormat("${maybe}", langList))),
					inline = true,
				})
			end
			embed:image(resultImage)
			embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
			embed:footerIcon(config.images.info)

			decoy:update(nil, embed:raw())

			return true
		else
			embed:description(parseFormat("${couldNotProcess}", langList))
			embed:color(config.colors.red:match(config.patterns.colorRGB.capture))
			embed:footerIcon(config.images.error)

			decoy:update(nil, embed:raw())

			return false
		end
	end
}):accept("yn", "ynm", "istrue", "itstrue", "truth")

commands:create({name = "owo",
	desc = "${owoifiesText}",
	usage = "${messageKey}",
	allowDm = true,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local text = data.content:sub(#args[1] + 2):lower()
		local increment = {"owo", "OWO", "OwO", "UwU", ">w<", "^w^", "uwu"}
		local replaces = {
			["r"] = "w",
			["l"] = "w",
			["r"] = "r",
			["ove"] = "uve",
			["n"] = "ny",
			["u"] = "wu",
			["e"] = "we",
			["ae"] = "wae",
			["ai"] = "wai",
			["ay"] = "yay",
			["o"] = "w",
			["uta"] = "wuta",
			["!"] = " " .. increment[math.random(#increment)]
		}

		if isFiltered(text, {"http://", "https://"}) then
			local text = parseFormat("${linksNotSupported}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		for word, replace in pairs(replaces) do
			text = text:gsub(word, replace)
			replaces["!"] = " " .. increment[math.random(#increment)]
		end

		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	end
})

commands:create({name = "laranjo",
	restrict = {"pt-br"},
	desc = "${laranjosText}",
	usage = "${messageKey}",
	allowDm = true,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local text = data.content:sub(#args[1] + 2):lower()
		local replaces = {
			["inho%s"] = "in ",
			["moral"] = "molau",
			["gostar"] = "gosta",
			["droga"] = "dorga",
			["tomar"] = "toma",
			["jog"] = "xog",
			["morada"] = "molada",
			["mãe"] = "mai",
			["mae"] = "mai",
			["via"] = "fia",
			["dinh"] = "tinh",
			["viad"] = "fiat",
			["sexual"] = "sexu uau",
			["aparentemente"] = "apaentimenti",
			["virtu"] = "vitu",
			["vazi"] = "fasi",
			["alvez"] = "alveis",
			["nheci"] = "nhesi",
			["para"] = "pa",
			["import"] = "impot",
			["hoje"] = "oje",
			["guês"] = "gueis",
			["escreve"] = "esqueve",
			["otario"] = "otairu",
			["pergunt"] = "pegunt",
			["vamo"] = "famu",
			["voce"] = "fose",
			["vc"] = "fose",
			["você"] = "fose",
			["iau"] = "inhau",
			["ch"] = "x",
			["ão"] = "au",
			["ç"] = "s",
			["ss"] = "ç",
			["tou"] = "to",
			["desde"] = "desd",
			["demonio"] = "the monio",
			["demônio"] = "the monio",
			["baby"] = "beibe",
			["me fudend"] = "mifu den",
			["gay"] = "guei",
			["olha"] = "oia",
			["pra"] = "pa",
			["fica"] = "fika",
			["qu"] = "k",
			["esto"] = "sto",
			["esta"] = "sta",
			["está"] = "stá",
			["com"] = "co",
			["bom"] = "baum",
			["voc"] = "oc",
			["endo"] = "eno",
			["oda"] = "ota",
			["todo"] = "tudu",
			["alho"] = "aiu",
			["filha"] = "fia",
			["filho"] = "fio",
			["er"] = "e",
			["êr"] = "ê",
			["ou"] = "o",
			["é"] = "eh",
			["rr"] = "r",
			["ado"] = "adu",
			["can"] = "kan",
			["boa"] = "poa",
		}

		if isFiltered(text, {"http://", "https://"}) then
			local text = parseFormat("${linksNotSupported}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		for word, replace in pairs(replaces) do
			text = text:gsub(word, replace)
		end

		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	end
}):accept("lar")

commands:create({name = "youtube",
	desc = "${searchesYoutubeVideo}",
	usage = "${messageKey}",
	cd = 15,

	func = function(data)
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

		local arwLeft = getEmoji(config.emojis.arwLeft, "name", baseGuild)
		local arwRight = getEmoji(config.emojis.arwRight, "name", baseGuild)

		local firstTime = true
		local decoyBird = bird:post(getLoadingEmoji(), nil, data.channel)
		local searchTerms = data.content:sub(#args[1] + 2):gsub(" ", "+")
		local searchResult = apis.search:youtubeSearch(searchTerms)
		local youtubeLink = "https://www.youtube.com/watch?v=%s"

		local page = 1
		local pages = 50

		if searchResult == nil or searchResult.items == nil then
			local text = parseFormat("${videoNotFoundTerms}", langList, searchTerms)
			local embed = replyEmbed(text, data.message, "warn")

			printf("Search error for term --> %s", searchTerms)
			decoyBird:update(nil, embed:raw())

			return false
		end

		pages = #searchResult.items

		local function showPage()
			local curVideo = searchResult.items[page]

			if not curVideo then
				local text = parseFormat("${videoNotFoundTerms}", langList, searchTerms)
				local embed = replyEmbed(text, data.message, "error")

				decoyBird:update(nil, embed:raw())

				return false
			end

			local snippet = curVideo.snippet

			decoyBird:update(format(youtubeLink, curVideo.id.videoId), nil)

			if firstTime == true then
				firstTime = false
				message = decoyBird.message
				blinker = blink(message, config.meta.reactionTimeout, {data.user.id})

				message:addReaction(arwLeft)
				message:addReaction(arwRight)

				blinker:on(arwLeft.id, function()
					page = max(1, page - 1)
					message:removeReaction(arwLeft, data.user.id)
					showPage()
				end)

				blinker:on(arwRight.id, function()
					page = min(pages, page + 1)
					message:removeReaction(arwRight, data.user.id)
					showPage()
				end)
			end
		end

		showPage()

		return true
	end
}):accept("yt", "video")

--[[commands:create({name = "google",
	category = category,
	desc = "${teachesToGoogle}",
	usage = "${messageKey}",
	level = 5,
	allowDm = true,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		if args[2] == nil then
			local text = parseFormat("${missingArg}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local arwLeft = getEmoji(config.emojis.arwLeft, "name", baseGuild)
		local arwRight = getEmoji(config.emojis.arwRight, "name", baseGuild)

		local firstTime = true
		local decoyBird = bird:post(getLoadingEmoji(), nil, data.channel)
		local searchTerms = data.content:sub(#args[1] + 2):gsub(" ", "+")
		local searchResult = apis.search:youtubeSearch(searchTerms)
		local youtubeLink = "https://www.youtube.com/watch?v=%s"

		local page = 1
		local pages = 50

		if searchResult == nil or searchResult.items == nil then
			local text = parseFormat("${videoNotFoundTerms}", langList, searchTerms)
			local embed = replyEmbed(text, data.message, "warn")

			printf("Search error for term --> %s", searchTerms)
			decoyBird:update(nil, embed:raw())

			return false
		end

		pages = #searchResult.items

		local function showPage()
			local curVideo = searchResult.items[page]

			if not curVideo then
				local text = parseFormat("${videoNotFoundTerms}", langList, searchTerms)
				local embed = replyEmbed(text, data.message, "error")

				decoyBird:update(nil, embed:raw())

				return false
			end

			local snippet = curVideo.snippet

			decoyBird:update(format(youtubeLink, curVideo.id.videoId), nil)

			if firstTime == true then
				firstTime = false
				message = decoyBird.message
				blinker = blink(message, config.meta.reactionTimeout, {data.user.id})

				message:addReaction(arwLeft)
				message:addReaction(arwRight)

				blinker:on(arwLeft.id, function()
					page = max(1, page - 1)
					message:removeReaction(arwLeft, data.user.id)
					showPage()
				end)

				blinker:on(arwRight.id, function()
					page = min(pages, page + 1)
					message:removeReaction(arwRight, data.user.id)
					showPage()
				end)
			end
		end

		showPage()

		return true
	end
}):accept("search", "lookup", "g")]]
