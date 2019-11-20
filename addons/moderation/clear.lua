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
	local args = data.args

	if not (args[2] and type(tonumber(args[2])) == "number") then
		local text = localize("${missingArg}: deleteNumber", guildLang)
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

	toDelete = v1

	if toDelete > maxBulk then
		local text = localize("${cannotDeleteMoreThanXMessages}; ${defaultAmountSetTo}", guildLang, maxBulk, maxBulk)
		local embed = replyEmbed(text, data.message, "warn")

		toDelete = maxBulk

		for i = 5, 1, - 1 do
			local countdown = localize("${startingIn}", guildLang, i)
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
			local knownError = getMatchingDiscordError(err:match("%d+"), guildLang)
			local noticeType
			local text

			if knownError then
				err = knownError
			end

			if deleted > 0 then
				text = localize("${failedContinueDetails} ${successDeletedXMessages}", guildLang, err, deleted)
				noticeType = "warn"
			else
				text = localize("${failedContinueDetails}", guildLang, err)
				noticeType = "error"
			end

			local embed = replyEmbed(text, data.message, noticeType)

			decoy:update(nil, embed:raw(), data.channel)

			return false
		end

		deleted = deleted + take

		if v1 > 100 then
			local text = localize("${deletedCurrentXMessages}", guildLang, deleted)
			local embed = replyEmbed(text, data.message, "info")

			decoy:update(getLoadingEmoji(), embed:raw(), data.channel)
		end
	end

	if v1 > 100 then
		wait(3)
	end

	local text = localize("${successDeletedXMessages}", guildLang, deleted)
	local embed = replyEmbed(text, data.message, "ok")

	decoy:update(nil, embed:raw(), data.channel)

	return true
end

return {config = _config, func = _function}
