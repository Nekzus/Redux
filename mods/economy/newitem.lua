local _config = {
	name = "newitem",
	desc = "${createsStoreItem}",
	usage = "${keyKey} = ${valueKey}",
	aliases = {"ni", "createitem", "ci"},
	cooldown = 0,
	level = 5,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local langList = langs[guildLang]
	local args = data.args

	storeTempData = storeTempData or {}

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
				if not v.picked then
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
				picked = false,
				default = "${noNameSpecified}",
				title = "$<storeItemName>",
				short = "name",
			},
			itemDesc = {
				picked = true,
				default = "${noDescSpecified}",
				title = "$<storeItemDesc>",
				short = "desc",
			},
			itemPrice = {
				picked = false,
				default = 0,
				title = "$<storeItemPrice>",
				short = "price",
			},
			itemStock = {
				picked = false,
				default = 0,
				title = "$<storeItemStock>",
				short = "stock",
			},

			giveRole = {
				picked = true,
				default = 0,
				title = "$<storeItemAwardRole>",
				short = "give role",
			},
			giveCash = {
				picked = true,
				default = 0,
				title = "$<storeItemAwardCash>",
				short = "give cash",
			},
			giveItem = {
				picked = true,
				default = "",
				title = "$<storeItemAwardItem>",
				short = "give item",
			},
			giveReply = {
				picked = true,
				default = "${inventoryItemUsed}",
				title = "$<storeItemReplyUsed>",
				short = "reply",
			},

			reqRole = {
				picked = true,
				default = 0,
				title = "$<storeItemRequiredRole>",
				short = "need role",
			},
			reqCash = {
				picked = true,
				default = 0,
				title = "$<storeItemRequiredCash>",
				short = "need cash",
			},
			reqItem = {
				picked = true,
				default = 0,
				title = "$<storeItemRequiredItem>",
				short = "need item",
			},
			reqTime = {
				picked = true,
				default = 0,
				title = "$<storeItemRequiredTime>",
				short = "need time",
			},

			takeRole = {
				picked = true,
				default = 0,
				title = "$<storeItemTakeRole>",
				short = "need role",
			},
			takeCash = {
				picked = true,
				default = 0,
				title = "$<storeItemTakeCash>",
				short = "need cash",
			},
			takeItem = {
				picked = true,
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
			for _, text in next, sentence:split("&&")
			do
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
					order.name.picked = true
				elseif inList(k, {"description", "desc", "d"}) then
					info.desc = v
					order.desc.picked = true
				elseif inList(k, {"price", "p", "value", "v"}) then
					local n = tonumber(v)

					if not n then
						local text = parseFormat("${missingArg}", langList)
						local embed = replyEmbed(text, data.message, "error")

						bird:post(nil, embed:raw(), data.channel)

						return false
					end

					info.price = math.max(0, n)
					order.price.picked = true
				elseif inList(k, {"stock", "stck", "stk", "st", "s"}) then
					local n = tonumber(v)

					if not n then
						local text = parseFormat("${missingArg}", langList)
						local embed = replyEmbed(text, data.message, "error")

						bird:post(nil, embed:raw(), data.channel)

						return false
					end

					info.stock = math.max(0, n)
					order.stock.picked = true
				elseif inList(k, {"role", "rol", "rl", "r"}) then
					local role = getRole(v, "name", lastData.guild)

					if not role then
						local text = parseFormat("${missingArg}", langList)
						local embed = replyEmbed(text, data.message, "error")

						bird:post(nil, embed:raw(), data.channel)

						return false
					end

					info.role = role.id
					order.role.picked = true
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

return {config = _config, func = _function}
