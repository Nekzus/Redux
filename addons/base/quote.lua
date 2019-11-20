local _config = {
	name = "quote",
	desc = "${quotesMesage}",
	usage = "${messageKey}",
	aliases = {"q", "quo"},
	cooldown = 3,
	level = 0,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	if not args[2] then
		return replyEmbed(localize("${missingArg}", guildLang), data.message, "error")
	end

	local tries = 20
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
		local jumpTo = localize("[${jumpToMessage}](%s)", guildLang, targetMessage.link)
		local sentBy = localize("${messageSentBy}", langs[guildLang], targetMessage.author.tag)
		local embed = newEmbed()

		embed:author(sentBy)
		embed:authorImage(targetMessage.author.avatarURL)
		embed:description(format("%s\n\n%s", targetMessage.content, jumpTo))
		embed:color(paint("blue"))
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		bird:post(nil, embed:raw(), data.channel)

		return true
	else
		local text = localize("${messageWithTermsNotFound}", guildLang, terms)
		local embed = replyEmbed(text, data.message, "warn")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end
end

return {config = _config, func = _function}
