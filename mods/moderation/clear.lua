local _config = {
	name = "clear",
	desc = "${purgesMessages}",
	usage = "${numKey}",
	aliases = {"purge", "delete", "del", "bulk", "clean", "clr", "cln", "cl"},
	cooldown = 0,
	level = 2,
	direct = false,
	perms = {"manageMessages"},
}

local _function = function(data)
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

	local maxBulk = 10000
	local perBulk = 100

	local toDelete = 0
	local deleted = 0

	local decoy = bird:post(getLoadingEmoji(), nil, data.channel)
	local v1 = tonumber(args[2])

	if type(v1) == "number" then
		toDelete = v1

		if toDelete > maxBulk then
			local text = parseFormat("${cannotDeleteMoreThanXMessages}; ${defaultAmountSetTo}", langList, maxBulk, maxBulk)
			local embed = replyEmbed(text, data.message, "warn")

			toDelete = maxBulk

			for i = 5, 1, - 1 do
				local countdown = parseFormat("${startingIn}", langList, i)
				decoy:update(countdown, embed:raw(), data.channel)
				wait(1)
			end
		end

		while toDelete > 0 do
			local take = min(perBulk, toDelete)

			toDelete = toDelete - take

			local list = data.channel:getMessagesBefore(data.message.id, take):toArray()
			local success, err = data.channel:bulkDelete(list)

			if not success then
				local knownError = getMatchingDiscordError(err:match("%d+"), langList)
				local noticeType
				local text

				if knownError then
					err = knownError
				end

				if deleted > 0 then
					text = parseFormat("${failedContinueDetails} ${successDeletedXMessages}", langList, err, deleted)
					noticeType = "warn"
				else
					text = parseFormat("${failedContinueDetails}", langList, err)
					noticeType = "error"
				end

				local embed = replyEmbed(text, data.message, noticeType)

				decoy:update(nil, embed:raw(), data.channel)

				return false
			end

			deleted = deleted + take

			if v1 > 100 then
				local text = parseFormat("${deletedCurrentXMessages}", langList, deleted)
				local embed = replyEmbed(text, data.message, "info")

				decoy:update(getLoadingEmoji(), embed:raw(), data.channel)
			end
		end

		if v1 > 100 then
			wait(3)
		end

		local text = parseFormat("${successDeletedXMessages}", langList, deleted)
		local embed = replyEmbed(text, data.message, "ok")

		decoy:update(nil, embed:raw(), data.channel)

		return true
	end

	return false
end

return {config = _config, func = _function}
