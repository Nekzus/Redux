local _config = {
	name = "viewmute",
	desc = "${showsMutes}",
	usage = "${userKey}",
	aliases = {"viewmutes", "mutes", "vmt", "viewmt", "vmute", "vmutes"},
	cooldown = 2,
	level = 1,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langData = langs[guildLang]
	local args = data.args

	local tempMutes = guildData:get("mutes")

	local mentioned = data.message.mentionedUsers.first
	local user

	if mentioned then
		user = data.guild:getMember(mentioned.id)
	end

	if user then
		local muteData = guildData:get("mutes"):raw()[user.id]

		if not muteData then
			local text = parseFormat("${followingUserNotMuted}", langData, user.name)
			local embed = replyEmbed(text, data.message, "warn")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local embed = newEmbed()

		local newTime = os.time()
		local elapsedTime = newTime - muteData.added
		local formalMuteTime = parseFormat(timeLong(muteData.duration - elapsedTime), langData)

		embed:title(mentioned.tag)

		embed:field({
			name = parseFormat("${timeLeft}", langData),
			value = formalMuteTime,
			inline = true
		})

		embed:field({
			name = parseFormat("${mod}", langData),
			value = format("<@!%s>", muteData.moderator),
			inline = true
		})

		embed:field({
			name = parseFormat("${reason}", langData),
			value = muteData.reason or parseFormat("${noReason}", langData),
			inline = true
		})

		embed:color(config.colors.blue)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		bird:post(nil, embed:raw(), data.channel)

		return true
	else
		local listTotal = 0
		local listItems = {}

		for userId, muteData in pairs(tempMutes:raw()) do
			insert(listItems, muteData)
			listTotal = listTotal + 1
		end

		sort(listItems, function(a, b)
			return a.duration < b.duration
		end)

		local perPage = 10
		local page = tonumber(args[2]) or 1

		local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuild)
		local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuild)
		local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuild)

		local decoyBird
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
				local elapsedTime = newTime - obj.added
				local formalMuteTime = parseFormat(timeLong(obj.duration - elapsedTime), langData)

				result = parseFormat("%s%s <@!%s>: %s", langData, result, topicEmoji.mentionString, obj.userId, formalMuteTime)
			end

			local pages = listTotal / perPage

			if tostring(pages):match("%.%d+") then
				pages = math.max(1, tonumber(tostring(pages):match("%d+") + 1))
			end

			embed:field({
				name = parseFormat("${mutedUsers} (%s/%s) [${page} %s/%s]", langData, inPage, listTotal, page, pages),
				value = (result ~= "" and result or parseFormat("${noResults}", langData))
			})

			embed:color(config.colors.blue)
			embed:footerIcon(config.images.info)
			signFooter(embed, data.author, guildLang)

			if listTotal <= perPage then
				decoyBird = decoyBird == nil and bird:post(nil, embed:raw(), data.channel)
				or decoyBird:update(nil, embed:raw())

				return true
			end

			if decoyBird == nil then
				decoyBird = bird:post(nil, embed:raw(), data.channel)
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
			else
				decoyBird:update(nil, embed:raw())
			end
		end

		showPage()
	end

	return true
end

return {config = _config, func = _function}
