commands:create({name = "whois",
	desc = "${returnsUserInfo}",
	usage = "${userKey}",
	allowDm = false,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		if not specifiesUser(data.message) then
			local text = parseFormat("${specifyUser}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local guild = data.guild
		local member = data.message.mentionedUsers.first
		local embed = newEmbed()

		embed:image(member.user.avatarURL)
		embed:field({name = parseFormat("${name}", langList), value = (member.nickname and format("%s (%s)", member.username, member.nickname) or member.username), inline = true})
		embed:field({name = parseFormat("${discrim}", langList), value = member.discriminator, inline = true})
		embed:field({name = parseFormat("${id}", langList), value = member.id, inline = true})
		embed:field({name = parseFormat("${status}", langList), value = member.status, inline = true})
		embed:field({name = parseFormat("${joinedDisc}", langList), value = discordia.Date.fromSnowflake(member.id):toISO("T", "Z"), inline = true})
		embed:field({name = parseFormat("${joinedServer}", langList), value = member.joinedAt, member.joinedAt:gsub("%..*", ""):gsub("T", " ") or "?", inline = true})

		embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		bird:post(nil, embed:raw(), data.channel)

		return true
	end
}):accept("minfo", "uinfo", "userinfo", "wis", "winfo")

local embedTempData = {}
commands:create({name = "embed",
	desc = "${constructsEmbed}",
	usage = "${keyKey} = ${valueKey}",
	level = 1,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local sentence = data.content:sub(#args[1] + 2)
		local activeEdit = embedTempData[data.user.id]
		local embed, botEmbed, errorEmbed, lastData

		if activeEdit then
			embed = activeEdit.embed
			botEmbed = activeEdit.botEmbed
			errorEmbed = activeEdit.errorEmbed
			lastData = activeEdit.data

			if inList(args[2], config.terms.done) then
				local toChannel = args[3] and getTextChannel(args[3], "name", data.guild)

				embedTempData[data.user.id] = nil

				if toChannel then
					bird:post(nil, embed:raw(), toChannel)
				else
					botEmbed:update(nil, embed:raw())
				end

				return true
			end

			if lastData.guild.id ~= data.guild.id then
				local finishCommand = format("%s done", data.command)
				local editLostMessage = parseFormat("${userEmbedEditLost} ${embedFinishTip2}", langList, data.user.username, finishCommand)
				local jumpTo = parseFormat("[${jumpToMessage}](%s)", langList, botEmbed:getMessage().link)
				local embed = newEmbed()

				embed:description(format("%s\n\n%s", editLostMessage, jumpTo))
				embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
				embed:footerIcon(config.images.info)
				signFooter(embed, lastData.author, guildLang)

				bird:post(nil, embed:raw(), data.channel)

				return false
			end

			if args[2] == nil or args[3] == nil then
				local text = parseFormat("${missingArg}", langList)
				local embed = replyEmbed(text, data.message, "error")

				bird:post(nil, embed:raw(), data.channel)

				return false
			end

			if errorEmbed then
				errorEmbed:delete()
			end
		else
			embed = newEmbed() --replyEmbed(nil, data.message, "info")
			embed:timestamp(discordia.Date():toISO("T", "Z"))
			embedTempData[data.author.id] = {embed = embed, data = data}

			local text = parseFormat("${editModeResult}", langList, data.author.tag)

			botEmbed = bird:post(text, embed:raw(), data.channel)
			embedTempData[data.author.id].botEmbed = botEmbed
		end

		if match(sentence, config.patterns.keyValue.base) then
			local success, err = pcall(function()
				for _, text in next, sentence:split("&&")
				do
					local k, v = match(text, config.patterns.keyValue.capture)

					k = k:lower()

					if inList(k, {"title", "t"}) then
						embed:title(v)
					elseif inList(k, {"color", "col", "clr", "c"}) then
						embed:color(v:match("(%d+)%s(%d+)%s(%d+)"))
					elseif inList(k, {"description", "desc", "d"}) then
						embed:description(v)
					elseif inList(k, {"image", "img", "i"}) then
						embed:image(v)
					elseif inList(k, {"author", "auth", "aut", "a"}) then
						embed:author(v)
					elseif inList(k, {"authorimage", "authimg", "autimg", "aimg", "ai"}) then
						embed:authorImage(v)
					elseif inList(k, {"authorurl", "authurl", "auturl", "aurl", "au"}) then
						embed:authorUrl(v)
					elseif inList(k, {"footer", "foot", "ftr", "ft", "f"}) then
						embed:footer(v)
					elseif inList(k, {"footericon", "footi", "ftri", "fti", "fi"}) then
						embed:footerIcon(v)
					end
				end
			end)

			if not success then
				if err and type(err) == "string" then
					local errPath, errFileLine = err:match("(%a*)/(%a*.lua%p%d*)")

					err = gsub(err, "%a%:%/", "")
					err = gsub(err, "%a+%/", "")

					if errPath and errFileLine then
						err = gsub(err, errFileLine, format("..%s/%s", errPath, errFileLine))
					end
				end

				local text = parseFormat("${luaNotSupported}; \n`%s`", langList, err)
				local embed = replyEmbed(text, data.message, "error")
				local errorEmbed = bird:post(nil, embed:raw(), data.channel)

				embedTempData[data.author.id].errorEmbed = errorEmbed
			end
		end

		if botEmbed then
			local finishCommand = format("%s done", data.command)

			botEmbed:update(parseFormat("${editModeResult}; ${embedFinishTip}", langList, data.author.tag, finishCommand), embed:raw())
			embedTempData[data.author.id].botEmbed = botEmbed
		else
			embedTempData[data.author.id] = nil
		end
	end
}):accept("emb", "e")

commands:create({name = "eval",
	desc = "${evalsMath}",
	usage = "${equationKey}",
	allowDm = true,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		if not (args[2]) then
			local text = parseFormat("${missingArg}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local input = data.content:sub(#args[1] + 2)
		local success, output = pcall(eval, tostring(input))
		local embed = replyEmbed(nil, data.message, "ok")

		embed:field({name = parseFormat("${inputResult}", langList), value = "```" .. input .."```", inline = true})
		embed:field({name = parseFormat("${outputResult}", langList), value = "```" .. output .."```", inline = true})

		if output and type(output) == "string" then
			if output:lower():find("inv")
			or output:lower():find("not")
			or output:lower():find("err") then
				embed:color(config.colors.red:match(config.patterns.colorRGB.capture))
				embed:footerIcon(config.images.error)
			end
		end

		bird:post(nil, embed:raw(), data.channel)

		return true
	end
}):accept("ev", "math")

commands:create({name = "say",
	desc = "${botSays}",
	usage = "${messageKey}",
	allowDm = true,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		if not (args[2]) then
			local text = parseFormat("${missingArg}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local canDelete = data.member and saves.global:get(data.guild.id):raw().deleteCommand
		canDelete = canDelete == true

		local value = data.content:sub(#args[1] + 2)
		local embed = replyEmbed(value, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		if not private and canDelete then
			data.message:delete()
		end

		return true
	end
}):accept("s", "repeat", "rep", "speak")

commands:create({name = "dbemote",
	desc = "${showsEmote}",
	usage = "${emoteKey}",
	allowDm = true,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		if not (args[2]) then
			local text = parseFormat("${missingArg}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local value = data.content:sub(#args[1] + 2)
		local text = parseFormat("${unicodeResult}", langList, value)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	end
}):accept("dbe")

commands:create({name = "setuser",
	desc = "${setsUsername}",
	usage = "",
	level = 5,
	allowDm = true,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		if not (args[2]) then
			local text = parseFormat("${missingArg}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local value = data.content:sub(#args[1] + 2)
		client:setUsername(value)

		local text = parseFormat("${usernameSet}", langList, text)
		local embed = replyEmbed(embed, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	end
}):accept("suser", "su")

commands:create({name = "setgame",
	desc = "${setsBotGame}",
	usage = "",
	level = 5,
	allowDm = true,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		if not (args[2]) then
			local text = parseFormat("${missingArg}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local value = data.content:sub(#args[1] + 2)
		client:setGame(value)

		local text = parseFormat("${playingStatusSet}", langList, text)
		local embed = replyEmbed(embed, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	end
}):accept("sgame", "sg")

commands:create({name = "setprefix",
	desc = "${setsPrefix}",
	usage = "${valueKey}",
	level = 3,

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

		local guildData = saves.global:get(data.guild.id)
		local valueSet = guildData:set("prefix", args[2])

		if valueSet then
			local text = parseFormat("${beenDefined}", langList, "prefix", valueSet)
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			local text = parseFormat("${noAllowEdit}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end
}):accept("sprefix", "prefix", "prfx", "sprfx")

commands:create({name = "setlang",
	desc = "${setsLang}",
	usage = "${valueKey}",
	level = 3,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		if not (args[2]) then
			local text = parseFormat("${missingArg}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		if not langs[args[2]] then
			local text = parseFormat("${langNotFound}", langList, values)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local guildData = saves.global:get(data.guild.id)
		local valueSet = guildData:set("lang", args[2])

		langList = langs[args[2]]

		if valueSet then
			local text = parseFormat("${beenDefined}", langList, "lang", valueSet)
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			local text = parseFormat("${noAllowEdit}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end
}):accept("slang", "lang", "lng", "ln")

commands:create({name = "setdelcmd",
	desc = "${setsDelCmd}",
	usage = "${valueKey}",
	level = 5, -- 3

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

		local bool
		local v = args[2]:lower()

		local yesList = {
			"on",
			"true",
			"1",
			"+"
		}

		local noList = {
			"off",
			"false",
			"0",
			"-"
		}

		if isFiltered(v, yesList) then
			bool = true
		elseif isFiltered(v, noList) then
			bool = false
		end

		if bool == nil then
			local text = parseFormat("${missingArg}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local guildData = saves.global:get(data.guild.id)
		local valueSet = guildData:set("deleteCommand", bool)

		if valueSet ~= nil then
			local text = parseFormat("${beenDefined}", langList, "deleteCommand", valueSet)
			local embed = replyEmbed(text, data.message, "ok")

			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			local text = parseFormat("${noAllowEdit}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end
}):accept("sdelcmd", "delcmd", "deletecommands", "deletecommand", "setdeletecommand")

commands:create({name = "saveexit",
	desc = "${savesBotDataAndEdit}",
	usage = "",
	level = 5,
	allowDm = true,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		saveAllData()

		local text = parseFormat("${botDataSaved}", langList)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		client:setGame("Restarting..")
		client:stop()
		os.exit(0)
	end
}):accept("xsave", "shutdown", "off", "sexit")

commands:create({name = "patron",
	desc = "${addsPatron}",
	usage = "${userKey}",
	level = 5,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local user = data.message.mentionedUsers.first

		if not user then
			local text = parseFormat("${userNotFound}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local member = data.guild:getMember(user)

		if not data.message.mentionedUsers.first
		or not data.guild:getMember(user) then
			local text = parseFormat("${userNotFound}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local patrons = saves.track:get("patrons")
		local mPatron = patrons:raw()[member.id]
		local nLevel = tonumber(args[3])
		local changeOnly = false

		if mPatron then
			if nLevel == nil or mPatron.level == nLevel then
				local text = parseFormat("${alreadyPatron}", langList, member.tag)
				local embed = replyEmbed(text, data.message, "warn")

				bird:post(nil, embed:raw(), data.channel)

				return true
			else
				changeOnly = true
			end
		end

		local text = changeOnly and parseFormat("${patronLevelSet}", langList, member.tag, nLevel or 1)
		or parseFormat("${patronAdded}", langList, member.tag)
		local embed = replyEmbed(text, data.message, "ok")

		patrons:set(tostring(member.id), {level = nLevel or 1, added = os.time()})
		db.save(saves.track.bin, "track")
		bird:post(nil, embed:raw(), data.channel)

		return true
	end
}):accept("pat", "premium", "vip")

commands:create({name = "unpatron",
	desc = "${addsPatron}",
	usage = "${userKey}",
	level = 5,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local user = data.message.mentionedUsers.first

		if not user then
			local text = parseFormat("${userNotFound}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return true
		end

		local member = data.guild:getMember(user)

		if not data.message.mentionedUsers.first
		or not data.guild:getMember(user) then
			local text = parseFormat("${userNotFound}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return true
		end

		local patrons = saves.track:get("patrons")

		if not patrons:raw()[member.id] then
			local text = parseFormat("${notPatron}", langList, member.tag)
			local embed = replyEmbed(text, data.message, "warn")

			bird:post(nil, embed:raw(), data.channel)

			return true
		else
			local text = parseFormat("${patronRemoved}", langList, member.tag)
			local embed = replyEmbed(text, data.message, "ok")

			patrons:set(tostring(member.id), nil)
			db.save(saves.track.bin, "track")
			bird:post(nil, embed:raw(), data.channel)

			return true
		end
	end
}):accept("unpat", "rpat", "unpremium", "unvip")

commands:create({name = "reload",
	desc = "${reloadsBotModules}",
	usage = "",
	level = 5,
	allowDm = true,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local decoy = bird:post(getLoadingEmoji(), nil, data.channel)

		saveAllData()

		coroutine.wrap(function()
			commands:flushList()
			loadBot()
		end)()

		local text = parseFormat("${botModulesReloaded}", langList)
		local embed = replyEmbed(text, data.message, "ok")

		decoy:update(nil, embed:raw())

		return true
	end
}):accept("rel", "boot", "reboot", "restart")

commands:create({name = "lua",
	desc = "${allowsLua}",
	usage = "${codeKey}",
	level = 5,
	allowDm = true,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		if not (args[2]) then
			local text = parseFormat("${missingArg}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local decoy = bird:post(getLoadingEmoji(), nil, data.channel)
		local success, response = loadCode(data.content:sub(#args[1] + 2), data.message, {os = os, data = data})

		local embed = replyEmbed(response, data.message, (success and "ok" or "error"))

		decoy:update(nil, embed:raw())

		return true
	end
}):accept("run", "f", "code")

commands:create({name = "ping",
	desc = "${saysPong}",
	usage = "",
	cd = 5,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local text = parseFormat("${pong}!", langList)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	end
}):accept("p")

commands:create({name = "quote",
	desc = "${quotesMesage}",
	usage = "${messageKey}",
	cd = 3,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		if not args[2] then
			return replyEmbed(parseFormat("${missingArg}", langList), data.message, "error")
		end

		local decoy = bird:post(getLoadingEmoji(), nil, data.channel)
		local tries = 10
		local terms = data.content:sub(#args[1] + 2)
		local isNum = tonumber(terms)
		local targetMessage

		if isNum and #terms == 18 then
			targetMessage = data.channel:getMessage(terms)
		else
			local lastMessage = data.message
			local lastChecked

			for i = 1, tries do
				if not lastMessage or lastChecked == lastMessage then
					break
				end

				lastChecked = lastMessage
				local messagesCache = data.channel:getMessagesBefore(lastMessage.id, 100)
				local ret = {}

				for message in messagesCache:iter() do
					lastMessage = message

					if message.content:lower():match(terms) then
						ret[#ret + 1] = message
					end
				end

				if #ret > 0 then
					sort(ret, function(a, b)
						return a.createdAt < b.createdAt
					end)

					targetMessage = ret[#ret]

					break
				end
			end
		end

		if targetMessage then
			local jumpTo = parseFormat("[${jumpToMessage}](%s)", langList, targetMessage.link)
			local sentBy = parseFormat("${messageSentBy}", langs[guildLang], targetMessage.author.tag)
			local embed = newEmbed()

			embed:author(sentBy)
			embed:authorImage(targetMessage.author.avatarURL)
			embed:description(format("%s\n\n%s", targetMessage.content, jumpTo))
			embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
			embed:footerIcon(config.images.info)
			signFooter(embed, data.author, guildLang)

			decoy:update(nil, embed:raw())

			return true
		else
			local text = parseFormat("${messageWithTermsNotFound}", langList, terms)
			local embed = replyEmbed(text, data.message, "warn")

			decoy:update(nil, embed:raw())

			return false
		end
	end
}):accept("q")

commands:create({name = "invite",
	desc = "${invitesNekito}",
	usage = "",
	level = 5,
	allowDm = true,

	func = function(data) -- https://discordapp.com/api/oauth2/authorize?client_id=309586161876205579&permissions=8&scope=bot
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local text = parseFormat("${neksInvite}", langList, config.meta.invite)
		local embed = replyEmbed(text, data.message, "ok")

		bird:post(nil, embed:raw(), data.channel)

		return true
	end
}):accept("inv")
