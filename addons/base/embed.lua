local _config = {
	name = "embed",
	desc = "${constructsEmbed}",
	usage = "${keyKey} = ${valueKey}",
	aliases = {"emb", "e"},
	cooldown = 1,
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
	local editData = embedBuilderData[data.user.id]
	local lastData = editData and editData.data or data
	local lastEmbed = editData and editData.embed
	local lastDecoy = editData and editData.decoy

	if not lastEmbed then
		lastEmbed = enrich()
		lastEmbed:timestamp(discordia.Date():toISO("T", "Z"))
	end

	if not lastDecoy then
		local text = localize("${editModeResult}", guildLang, data.author.tag)
		lastDecoy = bird:post(text, lastEmbed:raw(), data.channel)
	end

	if inList(args[2], config.terms.done) then
		local channel = args[3] and getTextChannel(args[3], "name", data.guild)

		embedBuilderData[data.user.id] = nil

		if channel then
			bird:post(nil, lastEmbed:raw(), channel)
			lastDecoy:delete()
		else
			lastDecoy:update(nil, lastEmbed:raw())
		end

		return true
	end

	if lastData.guild.id ~= data.guild.id then
		local finishCommand = join(data.command, " done")
		local editLostMessage = localize("${userEmbedEditLost} ${embedFinishTip2}", guildLang, data.user.username, finishCommand)
		local jumpTo = localize("[${jumpToMessage}](%s)", guildLang, lastDecoy:getMessage().link)
		local embed = enrich()

		embed:description(join(editLostMessage, "\n\n", jumpTo))
		embed:color(paint.info)
		embed:footerIcon(config.images.info)

		signFooter(embed, lastData.author, guildLang)
		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	if not (args[2] and args[3]) then
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	if sentence:match(config.patterns.keyValue.base) then
		local success, err = pcall(function()
			for _, text in next, sentence:split("&&") do
				local key, value = text:match(config.patterns.keyValue.capture)

				key = key:lower()

				if inList(key, {"title", "t"}) then
					lastEmbed:title(value)
					
				elseif inList(key, {"color", "col", "clr", "c"}) then
					lastEmbed:color({value:match("(%d+)%s(%d+)%s(%d+)")})

				elseif inList(key, {"description", "desc", "d"}) then
					lastEmbed:description(value)

				elseif inList(key, {"image", "img", "i"}) then
					lastEmbed:image(value)

				elseif inList(key, {"author", "auth", "aut", "a"}) then
					lastEmbed:author(value)

				elseif inList(key, {"authorimage", "authimg", "autimg", "aimg", "ai"}) then
					lastEmbed:authorImage(value)

				elseif inList(key, {"authorurl", "authurl", "auturl", "aurl", "au"}) then
					lastEmbed:authorUrl(value)

				elseif inList(key, {"footer", "foot", "ftr", "ft", "f"}) then
					lastEmbed:footer(value)

				elseif inList(key, {"footericon", "footi", "ftri", "fti", "fi"}) then
					lastEmbed:footerIcon(value)
				end
			end
		end)
	end

	embedBuilderData[data.user.id] = {
		data = lastData,
		embed = lastEmbed,
		decoy = lastDecoy
	}

	lastDecoy:update(true, lastEmbed:raw())

	return true
end

return {config = _config, func = _function}
