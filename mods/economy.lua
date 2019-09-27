commands:create({name = "economy",
	desc = "${listsEconomyTopUsers}",
	usage = "${pageKey}",

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local guildEconomy = saves.economy:get(data.guild.id)

		local rList = {}
		local nCount = 0

		for memberId, memberEconomy in pairs(guildEconomy:get("users"):raw()) do
			insert(rList, {id = memberId, cash = memberEconomy.cash or 0, bank = memberEconomy.bank or 0})
			nCount = nCount + 1
		end

		sort(rList, function(a, b)
			return (a.bank + a.cash) > (b.bank + b.cash)
		end)

		local perPage = 10
		local page = tonumber(args[2]) or 1

		local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuild)
		local arwLeft = getEmoji(config.emojis.arwLeft, "name", baseGuild)
		local arwRight = getEmoji(config.emojis.arwRight, "name", baseGuild)

		local decoyBird
		local message

		local function showPage()
			local embed = newEmbed()
			local count = 0
			local result = ""

			for _, itemData in next, paginate(rList, perPage, page) do
				count = count + 1

				if result ~= "" then
					result = format("%s\n", result)
				end

				result = parseFormat("%s%s <@!%s>: %s %s", langList, result, topicEmoji.mentionString, itemData.id, guildEconomy:get("symbol"), affixNum(itemData.cash + itemData.bank))
			end

			local pages = nCount / perPage

			if tostring(pages):match("%.%d+") then
				pages = max(1, tonumber(tostring(pages):match("%d+") + 1))
			end

			embed:field({name = parseFormat("${economy} (%s/%s) [${page} %s/%s]", langList, count, nCount, page, pages), value = (result ~= "" and result or parseFormat("${noResults}", langList))})

			embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
			embed:footerIcon(config.images.info)
			signFooter(embed, data.author, guildLang)

			if nCount <= perPage then
				decoyBird = decoyBird == nil and bird:post(nil, embed:raw(), data.channel)
				or decoyBird:update(nil, embed:raw())

				return true
			end

			if decoyBird == nil then
				decoyBird = bird:post(nil, embed:raw(), data.channel)
				message = decoyBird.message
				blinker = blink(message, config.meta.reactionTimeout, {data.user.id})

				message:addReaction(arwLeft)
				message:addReaction(arwRight)

				blinker:on(arwLeft.id, function()
					page = max(1, page - 1)
					message:removeReaction(arwLeft, data.user.id)
					showPage()
				end)

				blinker:on(arwRight.id, function()
					page = min(pages, page + 1)
					message:removeReaction(arwRight, data.user.id)
					showPage()
				end)
			else
				decoyBird:update(nil, embed:raw())
			end
		end

		showPage()

		return true
	end
}):accept("top")

commands:create({name = "withdraw",
	desc = "${withdrawsCash}",
	usage = "${numKey}",

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		if not args[2] then
			local text = parseFormat("${missingArg}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local memberEconomy, guildEconomy = getMemberEconomy(data.user, data.guild)
		local memberCash = memberEconomy:get("cash", 0)
		local memberBank = memberEconomy:get("bank", 0)
		local symbol = guildEconomy:get("symbol")
		local value = args[2]

		if type(value) == "string" then
			if value:lower() == "all" then
				value = memberBank
			elseif value:lower() == "half" then
				value = memberBank / 2
			elseif value:match("%d+%%") then
				value = value:match("%d+")

				if value then
					value = (value / 100) * memberBank
				end
			else
				value = realNum(value)
			end
		end

		if value and type(value) == "number" then
			if value <= memberBank then
				local text = parseFormat("${cashWithdrawn}", langList, format("%s %s", symbol, affixNum(value)))
				local embed = replyEmbed(text, data.message, "ok")

				bird:post(nil, embed:raw(), data.channel)
				memberBank = memberEconomy:set("bank", memberBank - value)
				memberCash = memberEconomy:set("cash", memberCash + value)

				return true
			else
				local text = parseFormat("${insufficientFunds}; ${currentBankAmount}", langList, format("%s %s", symbol, memberBank))
				local embed = replyEmbed(text, data.message, "error")

				bird:post(nil, embed:raw(), data.channel)

				return false
			end
		else
			local text = parseFormat("${cashValueInvalid}", langList, data.author.tag, value)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end
}):accept("with", "wit")

commands:create({name = "deposit",
	desc = "${depositsCash}",
	usage = "${numKey}",

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		if not args[2] then
			local text = parseFormat("${missingArg}", langList)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end

		local memberEconomy, guildEconomy = getMemberEconomy(data.user, data.guild)
		local memberCash = memberEconomy:get("cash", 0)
		local memberBank = memberEconomy:get("bank", 0)
		local symbol = guildEconomy:get("symbol")
		local value = args[2]

		if type(value) == "string" then
			if value:lower() == "all" then
				value = memberCash
			elseif value:lower() == "half" then
				value = memberCash / 2
			elseif value:match("%d+%%") then
				value = value:match("%d+")

				if value then
					value = (value / 100) * memberCash
				end
			else
				value = realNum(value)
			end
		end

		if value and type(value) == "number" then
			if value <= memberCash then
				local text = parseFormat("${cashDeposited}", langList, format("%s %s", symbol, affixNum(value)))
				local embed = replyEmbed(text, data.message, "ok")

				bird:post(nil, embed:raw(), data.channel)
				memberCash = memberEconomy:set("cash", memberCash - value)
				memberBank = memberEconomy:set("bank", memberBank + value)

				return true
			else
				local text = parseFormat("${insufficientFunds}; ${currentCashAmount}", langList, format("%s %s", symbol, memberBank))
				local embed = replyEmbed(text, data.message, "error")

				bird:post(nil, embed:raw(), data.channel)

				return false
			end
		else
			local text = parseFormat("${cashValueInvalid}", langList, data.author.tag, value)
			local embed = replyEmbed(text, data.message, "error")

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	end
}):accept("dep", "depo")

-- needs fix
local storeTempData = {}
commands:create({name = "newitem",
	desc = "${createsStoreItem}",
	usage = "${keyKey} = ${valueKey}",
	level = 5,

	func = function(data)
		local private = data.member == nil
		local guildData = data.guildData
		local guildLang = data.guildLang
		local langList = langs[guildLang]
		local args = data.args

		local sentence = data.content:sub(#args[1] + 2)
		local activeEdit = storeTempData[data.user.id]
		local info, order
		local embed, botEmbed, errorEmbed, lastData

		if activeEdit then
			info = activeEdit.info
			order = activeEdit.order
			lastData = activeEdit.data

			if inList(args[2], config.terms.cancel) then
				storeTempData[data.user.id] = nil

				local text = parseFormat("${newItemCanceled}", langList)
				local embed = replyEmbed(text, data.message, "info")

				bird:post(nil, embed:raw(), data.channel)

				return true
			elseif inList(args[2], config.terms.done) then
				local missingValues = ""

				for k, v in next, order do
					if not v.chosen then
						if missingValues ~= "" then
							missingValues = format("%s, ", missingValues)
						end

						missingValues = format("%s%s", missingValues, k)
					end
				end

				if missingValues ~= "" then
					local text = parseFormat("${newItemMissing}", langList, missingValues)
					local embed = replyEmbed(text, data.message, "warn")

					bird:post(nil, embed:raw(), data.channel)

					return false
				end

				storeTempData[data.user.id] = nil

				local guildEconomy = getGuildEconomy(lastData.guild.id)
				local guildStore = guildEconomy:get("store", {})

				local text = parseFormat("${newItemCreated}", langList)
				local embed = replyEmbed(text, data.message, "ok")

				bird:post(nil, embed:raw(), data.channel)
				guildStore:set(newGuid(), info)

				return true
			end

			if lastData.guild.id ~= data.guild.id then
				local editLostMessage = parseFormat("${userItemEditLost}; ${itemFinishTip2}", langList, data.user.username, data.command)
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
		else
			info = {}
			order = {
				itemName = {
					chosen = false,
					default = "${noNameSpecified}",
					title = "$<storeItemName>",
					short = "name",
				},
				itemDesc = {
					chosen = true,
					default = "${noDescSpecified}",
					title = "$<storeItemDesc>",
					short = "desc",
				},
				itemPrice = {
					chosen = false,
					default = 0,
					title = "$<storeItemPrice>",
					short = "price",
				},
				itemStock = {
					chosen = false,
					default = 0,
					title = "$<storeItemStock>",
					short = "stock",
				},

				giveRole = {
					chosen = true,
					default = 0,
					title = "$<storeItemAwardRole>",
					short = "give role",
				},
				giveCash = {
					chosen = true,
					default = 0,
					title = "$<storeItemAwardCash>",
					short = "give cash",
				},
				giveItem = {
					chosen = true,
					default = "",
					title = "$<storeItemAwardItem>",
					short = "give item",
				},
				giveReply = {
					chosen = true,
					default = "${inventoryItemUsed}",
					title = "$<storeItemReplyUsed>",
					short = "reply",
				},

				reqRole = {
					chosen = true,
					default = 0,
					title = "$<storeItemRequiredRole>",
					short = "need role",
				},
				reqCash = {
					chosen = true,
					default = 0,
					title = "$<storeItemRequiredCash>",
					short = "need cash",
				},
				reqItem = {
					chosen = true,
					default = 0,
					title = "$<storeItemRequiredItem>",
					short = "need item",
				},
				reqTime = {
					chosen = true,
					default = 0,
					title = "$<storeItemRequiredTime>",
					short = "need time",
				},

				takeRole = {
					chosen = true,
					default = 0,
					title = "$<storeItemTakeRole>",
					short = "need role",
				},
				takeCash = {
					chosen = true,
					default = 0,
					title = "$<storeItemTakeCash>",
					short = "need cash",
				},
				takeItem = {
					chosen = true,
					default = 0,
					title = "$<storeItemTakeItem>",
					short = "need item",
				},
			}
			lastData = data

			embed = newEmbed()
			embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
			embed:footerIcon(config.images.info)
			signFooter(embed, data.author, guildLang)

			botEmbed = bird:post(nil, embed:raw(), data.channel)

			for k, v in next, order do
				info[k] = v.default
			end

			storeTempData[data.author.id] = {
				info = info,
				order = order,
				data = data,

				embed = embed,
				botEmbed = botEmbed
			}
		end

		local editor = storeTempData[data.author.id]
		local info = editor.info
		local order = editor.order

		if match(sentence, config.patterns.keyValue.base) then
			local guildEconomy = getGuildEconomy(lastData.guild.id)
			local guildStore = guildEconomy:get("store", {})

			local success, err = pcall(function()
				for _, text in next, sentence:split("&&") do
				local k, v = match(text, config.patterns.keyValue.capture)

				k = k:lower()

				if inList(k, {"name", "n", "title", "t"}) then
					for itemGuid, item in next, guildStore:raw() do
						if item.name == v then
							local text = parseFormat("${itemNameSpecifiedExists}", langList)
							local embed = replyEmbed(text, data.message, "warn")

							bird:post(nil, embed:raw(), data.channel)

							return false
						end
					end

					info.name = v
					order.name.chosen = true
				elseif inList(k, {"description", "desc", "d"}) then
					info.desc = v
					order.desc.chosen = true
				elseif inList(k, {"price", "p", "value", "v"}) then
					local n = tonumber(v)

					if not n then
						local text = parseFormat("${missingArg}", langList)
						local embed = replyEmbed(text, data.message, "error")

						bird:post(nil, embed:raw(), data.channel)

						return false
					end

					info.price = math.max(0, n)
					order.price.chosen = true
				elseif inList(k, {"stock", "stck", "stk", "st", "s"}) then
					local n = tonumber(v)

					if not n then
						local text = parseFormat("${missingArg}", langList)
						local embed = replyEmbed(text, data.message, "error")

						bird:post(nil, embed:raw(), data.channel)

						return false
					end

					info.stock = math.max(0, n)
					order.stock.chosen = true
				elseif inList(k, {"role", "rol", "rl", "r"}) then
					local role = getRole(v, "name", lastData.guild)

					if not role then
						local text = parseFormat("${missingArg}", langList)
						local embed = replyEmbed(text, data.message, "error")

						bird:post(nil, embed:raw(), data.channel)

						return false
					end

					info.role = role.id
					order.role.chosen = true
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

			storeTempData[data.author.id].errorEmbed = errorEmbed
		end
	end
end
}):accept("citem", "nitem", "additem", "createitem", "ni", "ci", "ai")

commands:create({name = "store",
category = category,
desc = "${showsServerStore}",
usage = "${numKey}",
level = 5,

func = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	local guildEconomy = getGuildEconomy(data.guild)
	local guildStore = guildEconomy:get("store")
	local symbol = guildEconomy:get("symbol")

	local nCount = 0
	local rList = {}

	for itemGuid, item in pairs(guildStore:raw()) do
		insert(rList, {name = item.name, desc = item.desc, price = item.price, quant = item.quant, roles = item.role})
		nCount = nCount + 1
	end

	sort(rList, function(a, b)
		return a.price > b.price
	end)

	local perPage = 10
	local page = tonumber(args[2]) or 1

	local topicEmoji = getEmoji(config.emojis.topic, "name", baseGuild)
	local arwLeft = getEmoji(config.emojis.arwLeft, "name", baseGuild)
	local arwRight = getEmoji(config.emojis.arwRight, "name", baseGuild)

	local decoyBird
	local message

	local function showPage()
		local embed = newEmbed()
		local count = 0
		local result = ""

		--[[embed:title(client.user.name)
        embed:description(parseFormat(
            "${storeBuyTip}\n${storeInfoTip}",
            langList, format("%s%s <%s> [%s]", data.prefix, "buy", "")
        ))]]

	for _, obj in next, paginate(rList, perPage, page) do
		count = count + 1

		if result ~= "" then
			result = format("%s\n", result)
		end

		result = format("%s%s **%s** - **%s** %s", result, symbol, obj.price, parseFormat(obj.name, langList), parseFormat(obj.desc, langList))
	end

	local pages = nCount / perPage

	if tostring(pages):match("%.%d+") then
		pages = tostring(pages):match("%d+")
		pages = tostring(tonumber(pages) + 1)
	end

	embed:field({name = parseFormat("${store} (%s/%s) [${page} %s/%s]", langList, count, nCount, page, pages), value = (result ~= "" and result or parseFormat("${noResults}", langList))})

	embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
	embed:footerIcon(config.images.info)
	signFooter(embed, data.author, guildLang)

	if nCount <= perPage then
		decoyBird = decoyBird == nil and bird:post(nil, embed:raw(), data.channel)
		or decoyBird:update(nil, embed:raw())

		return true
	end

	if decoyBird == nil then
		decoyBird = bird:post(nil, embed:raw(), data.channel)
		message = decoyBird.message
		blinker = blink(message, config.meta.reactionTimeout, {data.user.id})

		message:addReaction(arwLeft)
		message:addReaction(arwRight)

		blinker:on(arwLeft.id, function()
			page = max(1, page - 1)
			message:removeReaction(arwLeft, data.user.id)
			showPage()
		end)

		blinker:on(arwRight.id, function()
			page = min(pages, page + 1)
			message:removeReaction(arwRight, data.user.id)
			showPage()
		end)
	else
		decoyBird:update(nil, embed:raw())
	end
end

showPage()

return true
end
}):accept("market", "mkt", "mk", "str", "st")
--[[
- Crime (patronos escolhem) seleciona um crime aleatório em dificuldade [facil/média/difícil]

- Você vê a recompensa e a dificuldade da missão, tendo assim, a opção de decidir se quer ou não fazê-la

- Durante a escolha, pessoas podem se juntar a você (caso você liberar) para cometer um crime
	por consequência, a recompensa será repartida entre todos (caso houver sucesso)
	caso falhar, apenas um usuário aleatório será pego e punido

- Itens da loja (ou do mercado negro) poderão diminuir a dificuldade

https://www.ranker.com/list/crimes-youd-commit-if-you-could-get-away-with-it/dani-porter
]]
--[[
- Durante as missões de crime, o usuário ou um usuário aleatório será selecionado para executar um dos níveis
	do crime, durante esse processo, um usuário terá três opções dentro do bot que, por via de reactions
	escolherá a ação desejada.

- Ação de roubar uma pessoa:
	- nível 1 do roubo: modo de assalto: Em Silencio, Agressivo, Blitzkrieg
		dentre as três opções, uma delas poderá dar errado, resultando na prisão do membro
		caso der certo, todos os outros membros procedem juntos

	- nível 2 do roubo:
]]

-- quadro de missõs aleatórias
-- shinato - trocas no bot
-- player - missões secundarias (que podem conter drops)
-- braresa - facções com sistema similar a werewolf online (adicionar top 3 pra ter chat)
-- maquina de dinheiro
