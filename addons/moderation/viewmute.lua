local _config = {
	name = "viewmute",
	desc = "${showsMutes}",
	usage = "${userKey}",
	aliases = {"viewmutes", "mutes", "mts"},
	cooldown = 2,
	level = 1,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	local mentioned = data.message.mentionedUsers.first
	local user

	if mentioned then
		user = data.guild:getMember(mentioned.id)
	end

	local tempMutes = saves.temp:get("mutes")
	local guildMutes = guildData:get("mutes")

	if user then
		local guildMute = guildMutes:raw()[user.id]
		local tempMute = guildMute and tempMutes:raw()[guildMute.guid]
		
		if not (guildMute and tempMute) then
			local text = localize("${followingUserNotMuted}", guildLang, user.name)
			local embed = replyEmbed(text, data.message, "warn")

			bird:post(nil, embed:raw(), data.channel)
			return false
		end

		local embed = newEmbed()
		local elapsedTime = os.time() - guildMute.tick
		local formalMuteTime = localize(timeLong(guildMute.duration - elapsedTime), guildLang)

		embed:title(mentioned.tag)
		embed:field({
			name = localize("${timeLeft}", guildLang),
			value = formalMuteTime,
			inline = true
		})
		embed:field({
			name = localize("${mod}", guildLang),
			value = string.format("<@!%s>", guildMute.modId),
			inline = true
		})
		embed:field({
			name = localize("${reason}", guildLang),
			value = guildMute.reason or localize("${noReason}", guildLang),
			inline = true
		})

		embed:color(paint.info)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		bird:post(nil, embed:raw(), data.channel)

		return true
	else
		local listTotal = 0
		local listItems = {}

		for userId, guildMute in pairs(guildMutes:raw()) do
			table.insert(listItems, guildMute)
			listTotal = listTotal + 1
		end

		table.sort(listItems, function(a, b)
			return a.duration < b.duration
		end)

		local perPage = 10
		local page = tonumber(args[2]) or 1

		local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuild)
		local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuild)
		local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuild)

		local decoy
		local message

		local function showPage()
			local embed = newEmbed()
			local inPage = 0
			local result = ""

			for _, obj in next, paginate(listItems, perPage, page) do
				inPage = inPage + 1

				if result ~= "" then
					result = result .. "\n"
				end

				local newTime = os.time()
				local elapsedTime = newTime - obj.tick
				local formalMuteTime = localize(timeLong(obj.duration - elapsedTime), guildLang)

				result = localize("%s%s <@!%s>: %s", guildLang, result, topicEmoji.mentionString, obj.userId, formalMuteTime)
			end

			local pages = listTotal / perPage

			if tostring(pages):match("%.%d+") then
				pages = math.max(1, tonumber(tostring(pages):match("%d+") + 1))
			end

			embed:title(localize("${mutedUsers} (%s/%s) [${page} %s/%s]", guildLang, inPage, listTotal, page, pages))
			embed:description(result ~= "" and result or localize("${noResults}", guildLang))

			embed:color(paint.info)
			embed:footerIcon(config.images.info)
			signFooter(embed, data.author, guildLang)

			if listTotal <= perPage then
				if decoy == nil then
					decoy = bird:post(nil, embed:raw(), data.channel)
				else
					decoy:update(nil, embed:raw())
				end

				return true
			end

			if decoy == nil then
				decoy = bird:post(nil, embed:raw(), data.channel)
				blinker = blink(decoy:getMessage(), config.timeouts.reaction.value, {data.user.id})

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

				decoy:addReaction(arwDown)
				decoy:addReaction(arwUp)
			else
				decoy:update(nil, embed:raw())
			end
		end

		showPage()
	end

	return true
end

return {config = _config, func = _function}
