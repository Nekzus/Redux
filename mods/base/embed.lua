local _config = {
	name = "embed",
	desc = "${constructsEmbed}",
	usage = "${keyKey} = ${valueKey}",
	aliases = {"emb", "e"},
	cooldown = 0,
	level = 1,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	embedTempData = embedTempData or {}

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

return {config = _config, func = _function}
