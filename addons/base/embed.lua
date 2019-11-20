local _config = {
	name = "embed",
	desc = "${constructsEmbed}",
	usage = "${keyKey} = ${valueKey}",
	aliases = {"emb", "e"},
	cooldown = 0,
	level = 0,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	embedBuilderData = embedBuilderData or {}

	local sentence = data.content:sub(#args[1] + 2)
	local activeEdit = embedBuilderData[data.user.id]
	local embed, botEmbed, errorEmbed, lastData

	if activeEdit then
		embed = activeEdit.embed
		botEmbed = activeEdit.botEmbed
		errorEmbed = activeEdit.errorEmbed
		lastData = activeEdit.data

		if inList(args[2], config.terms.done) then
			local toChannel = args[3] and getTextChannel(args[3], "name", data.guild)

			embedBuilderData[data.user.id] = nil

			if toChannel then
				bird:post(nil, embed:raw(), toChannel)
			else
				botEmbed:update(nil, embed:raw())
			end

			return true
		end

		if lastData.guild.id ~= data.guild.id then
			local finishCommand = format("%s done", data.command)
			local editLostMessage = localize("${userEmbedEditLost} ${embedFinishTip2}", guildLang, data.user.username, finishCommand)
			local jumpTo = localize("[${jumpToMessage}](%s)", guildLang, botEmbed:getMessage().link)
			local embed = newEmbed()

			embed:description(format("%s\n\n%s", editLostMessage, jumpTo))
			embed:color(paint("blue"))
			embed:footerIcon(config.images.info)
			signFooter(embed, lastData.author, guildLang)

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		if args[2] == nil or args[3] == nil then
			local text = localize("${missingArg}", guildLang)
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
		embedBuilderData[data.author.id] = {embed = embed, data = data}

		local text = localize("${editModeResult}", guildLang, data.author.tag)

		botEmbed = bird:post(text, embed:raw(), data.channel)
		embedBuilderData[data.author.id].botEmbed = botEmbed
	end

	if match(sentence, config.patterns.keyValue.base) then
		local success, err = pcall(function()
			for _, text in next, sentence:split("&&")
			do
				local key, value = match(text, config.patterns.keyValue.capture)

				key = key:lower()

				if inList(key, {"title", "t"}) then
					embed:title(value)
				elseif inList(key, {"color", "col", "clr", "c"}) then
					embed:color(value:match("(%d+)%s(%d+)%s(%d+)"))
				elseif inList(key, {"description", "desc", "d"}) then
					embed:description(value)
				elseif inList(key, {"image", "img", "i"}) then
					embed:image(value)
				elseif inList(key, {"author", "auth", "aut", "a"}) then
					embed:author(value)
				elseif inList(key, {"authorimage", "authimg", "autimg", "aimg", "ai"}) then
					embed:authorImage(value)
				elseif inList(key, {"authorurl", "authurl", "auturl", "aurl", "au"}) then
					embed:authorUrl(value)
				elseif inList(key, {"footer", "foot", "ftr", "ft", "f"}) then
					embed:footer(value)
				elseif inList(key, {"footericon", "footi", "ftri", "fti", "fi"}) then
					embed:footerIcon(value)
				end
			end
		end)

		-- Caso houver alguma falha ao aplicar as alterações no embed, retorna
		-- uma mensagem menor logo abaixo do embed para notificar do erro para
		-- o usuário executando o comando
		if not success then
			if err and type(err) == "string" then
				local errPath, errFileLine = err:match("(%a*)/(%a*.lua%p%d*)")

				err = gsub(err, "%a%:%/", "")
				err = gsub(err, "%a+%/", "")

				if errPath and errFileLine then
					err = gsub(err, errFileLine, format("..%s/%s", errPath, errFileLine))
				end
			end

			local text = localize("${luaNotSupported}; \n`%s`", guildLang, err)
			local embed = replyEmbed(text, data.message, "error")
			local errorEmbed = bird:post(nil, embed:raw(), data.channel)

			embedBuilderData[data.author.id].errorEmbed = errorEmbed
		end
	end

	if botEmbed then
		local finishCommand = format("%s done", data.command)

		botEmbed:update(localize("${editModeResult}; ${embedFinishTip}", guildLang, data.author.tag, finishCommand), embed:raw())
		embedBuilderData[data.author.id].botEmbed = botEmbed
	else
		embedBuilderData[data.author.id] = nil
	end
end

return {config = _config, func = _function}
