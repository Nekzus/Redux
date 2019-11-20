local _config = {
	name = "youtube",
	desc = "${searchesYoutubeVideo}",
	usage = "${messageKey}",
	aliases = {"yt", "video"},
	cooldown = 15,
	level = 0,
	direct = true,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	if not args[2] then
		local text = localize("${missingArg}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local arwUp = getEmoji(config.emojis.arwUp, "name", baseGuild)
	local arwDown = getEmoji(config.emojis.arwDown, "name", baseGuild)

	local decoy
	local firstTime = true
	local searchTerms = data.content:sub(#args[1] + 2):gsub(" ", "+")
	local searchResult = apiYoutubeVideo(searchTerms)
	local youtubeLink = "https://www.youtube.com/watch?v=%s"
	local list = searchResult and searchResult.items

	local page = 1
	local pages = list and #list or 1

	if list == nil then
		local text = localize("${videoNotFoundTerms}", guildLang, searchTerms)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	local function showPage()
		local item = list[page]

		if not item then
			local text = localize("${videoNotFoundTerms}", guildLang, searchTerms)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		if decoy then
			decoy:update(format(youtubeLink, item.id.videoId), nil)
		else
			decoy = bird:post(format(youtubeLink, item.id.videoId), nil, data.channel)
		end

		if firstTime == true then
			firstTime = false
			blinker = blink(decoy:getMessage(), config.timeouts.reaction, {data.user.id})

			blinker:on(arwDown.id, function()
				page = min(pages, page + 1)

				if not private then
					decoy:removeReaction(arwDown, data.user.id)
				end

				showPage()
			end)

			blinker:on(arwUp.id, function()
				page = max(1, page - 1)

				if not private then
					decoy:removeReaction(arwUp, data.user.id)
				end

				showPage()
			end)

			decoy:addReaction(arwDown)
			decoy:addReaction(arwUp)
		end
	end

	showPage()

	return true
end

return {config = _config, func = _function}
