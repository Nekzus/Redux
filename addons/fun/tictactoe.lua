local _config = {
	name = "tictactoe",
	desc = "${}",
	usage = "",
	aliases = {"ttt", "tic"},
	cooldown = 0,
	level = 5,
	direct = false,
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

	if not specifiesUser(data.message) then
		local text = localize("${specifyUser}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsBot(data.message) then
		local text = localize("${noExecuteBot}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	elseif mentionsSelf(data.message) then
		local text = localize("${noExecuteSelf}", guildLang)
		local embed = replyEmbed(text, data.message, "error")

		bird:post(nil, embed:raw(), data.channel)

		return false
	end

	ticCallback = ticCallback or {}

	local player1 = data.member
	local player2 = data.mentionedUsers.first
	local playerRoom = ticCallback[player1.id]

	local function newBoard()
		return {
			0, 0, 0,
			0, 0, 0,
			0, 0, 0,
		}
	end

	local function renderBoard(list)
		local x = ":x:"
		local o = ":o:"
		local template = ""
		local replaces = {
			[1] = ":one:",
			[2] = ":two:",
			[3] = ":three:",
			[4] = ":four:",
			[5] = ":five:",
			[6] = ":six:",
			[7] = ":seven:",
			[8] = ":eight:",
			[9] = ":nine:",
		}

		local count = 0
		for num, emoji in next, replaces do
			template = append(template, emoji)
			count = count + 1
			if (count % 3) == 0 then
				template = append(template, "\n")
			end
		end

		count = 0
		return gsub(template, ":%a+:",
			function(key)
				count = count + 1
				return list[count] == 0 and key
				or list[count] == 1 and x
				or list[count] == 2 and o
			end
		)
	end

	print(renderBoard({
		1, 0, 2,
		0, 1, 2,
		1, 2, 1,
	}))

	local function gameFinished(list)
		local count = 0

		for i = 1, #list do
			if list[i] ~= 0 then
				count = count + 1
			end
		end

		return #list == count
	end

	if playerRoom then

	else
		playerRoom = {
			player1 = player1,
			player2 = player2,
			board = newBoard()
		}
	end
end

return {config = _config, func = _function}
