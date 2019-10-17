local _config = {
	name = "newitem",
	desc = "${createsStoreItem}",
	usage = "${keyKey} = ${valueKey}",
	aliases = {"ni", "createitem", "ci"},
	cooldown = 0,
	level = 3,
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
	local edit = storeTempData[data.user.id]

	local lastData = data
	local itemData
	local decoyBird

	local guildEconomy = getGuildEconomy(lastData.guild.id)
	local guildStore = guildEconomy:get("store", {})

	if edit then
		lastData = edit.data
		itemData = edit.itemData
		tempData = edit.tempData
		decoyBird = edit.decoyBird

		if inList(args[2], config.terms.cancel) then
			storeTempData[data.user.id] = nil

			local text = parseFormat("${newItemCanceled}", langList)
			local embed = replyEmbed(text, data.message, "info")

			bird:post(nil, embed:raw(), data.channel)

			return true

		elseif inList(args[2], config.terms.done) then
			local missingValues = ""

			for key, value in next, tempData do
				if value.required == true then
					if not itemData[key] then
						if missingValues ~= "" then
							missingValues = format("%s, ", missingValues)
						end

						missingValues = format("%s%s", missingValues, key)
					end
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
			guildStore:set(newGuid(), itemData)

			return true
		end

		if lastData.guild.id ~= data.guild.id then
			local finishCommand = format("%s cancel", data.command)
			local editLostMessage = parseFormat("${userItemEditLost} ${itemFinishTip2}", langList, data.user.username, finishCommand)
			local jumpTo = parseFormat("[${jumpToMessage}](%s)", langList, decoyBird.message.link)
			local embed = newEmbed()

			embed:description(format("%s\n\n%s", editLostMessage, jumpTo))
			embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
			embed:footerIcon(config.images.info)
			signFooter(embed, lastData.author, guildLang)

			bird:post(nil, embed:raw(), data.channel)

			return false
		end
	else
		lastData = data
		itemData = {createDate = os.time()}
		tempData = {
			-- Base definition of the current item
			itemName = {
				required = true,
				default = "${noNameSpecified}",
				title = "$<storeItemName>",
			},
			itemDesc = {
				required = false,
				default = "${noDescSpecified}",
				title = "$<storeItemDesc>",
			},
			itemPrice = {
				required = false,
				default = 0,
				title = "$<storeItemPrice>",
			},
			itemStock = {
				required = false,
				default = -1,
				title = "$<storeItemStock>",
			},

			-- Awards that will be granted once the current item is utilized
			giveRole = {
				required = false,
				default = "",
				title = "$<storeItemAwardRole>",
			},
			giveCash = {
				required = false,
				default = 0,
				title = "$<storeItemAwardCash>",
			},
			giveItem = {
				required = false,
				default = "",
				title = "$<storeItemAwardItem>",
			},
			giveReply = {
				required = false,
				default = "${inventoryItemUsed}",
				title = "$<storeItemReplyUsed>",
			},

			-- picked items that will not be consumed but must be present to
			-- allow the usage of the current item
			reqRole = {
				required = false,
				default = "",
				title = "$<storeItemRequiredRole>",
			},
			reqCash = {
				required = false,
				default = 0,
				title = "$<storeItemRequiredCash>",
			},
			reqItem = {
				required = false,
				default = "",
				title = "$<storeItemRequiredItem>",
			},
			reqTime = {
				required = false,
				default = 0,
				title = "$<storeItemRequiredTime>",
			},

			-- These will be taken from the user upon the usage
			takeRole = {
				required = false,
				default = "",
				title = "$<storeItemTakeRole>",
			},
			takeCash = {
				required = false,
				default = 0,
				title = "$<storeItemTakeCash>",
			},
			takeItem = {
				required = false,
				default = "",
				title = "$<storeItemTakeItem>",
			},
		}

		for _, fill in next, {"itemDesc", "itemPrice", "itemStock", "giveReply"} do
			local fillData = tempData[fill]

			if fillData then
				itemData[fill] = fillData.default
			else
				printf("Information not found in itemData for %s", fill)
			end
		end

		storeTempData[data.author.id] = {
			data = data,
			itemData = itemData,
			tempData = tempData,
			decoyBird = decoyBird
		}
	end

	if match(sentence, config.patterns.keyValue.base) then
		for _, text in next, sentence:split("&&")
		do
			local key, value = match(text, config.patterns.keyValue.capture)

			key = key:lower()

			if inList(key, {"name", "itemname", "item name", "n"}) then -- Base item-data
				for itemGuid, item in next, guildStore:raw() do
					if item.itemName == value then
						local text = parseFormat("${itemNameSpecifiedExists}: %s", langList, item.itemName)
						local embed = replyEmbed(text, data.message, "warn")

						bird:post(nil, embed:raw(), data.channel)

						return false
					end
				end

				itemData.itemName = value

			elseif inList(key, {"desc", "itemdesc", "item desc", "item description", "d"}) then
				itemData.itemDesc = value

			elseif inList(key, {"price", "itemprice", "item price", "p"}) then
				local price = realNum(value)

				if not price then
					local text = parseFormat("${missingArg}: itemPrice", langList)
					local embed = replyEmbed(text, data.message, "error")

					bird:post(nil, embed:raw(), data.channel)

					return false
				end

				itemData.itemPrice = max(0, price)

			elseif inList(key, {"stock", "itemstock", "item stock", "s"}) then
				local stock = realNum(value)

				if not stock then
					local text = parseFormat("${missingArg}: itemStock", langList)
					local embed = replyEmbed(text, data.message, "error")

					bird:post(nil, embed:raw(), data.channel)

					return false
				end

				itemData.itemStock = max(-1, stock)

			elseif inList(key, {"giverole", "give role", "gr"}) then -- Attributes that will be given
				local role = getRole(value, "name", lastData.guild)

				if not role then
					local text = parseFormat("${missingArg}: giveRole", langList)
					local embed = replyEmbed(text, data.message, "error")

					bird:post(nil, embed:raw(), data.channel)

					return false
				end

				itemData.giveRole = role.id

			elseif inList(key, {"givecash", "give cash", "gc"}) then
				value = realNum(value)

				if not value then
					local text = parseFormat("${missingArg}: giveCash", langList)
					local embed = replyEmbed(text, data.message, "error")

					bird:post(nil, embed:raw(), data.channel)

					return false
				end

				itemData.giveCash = value

			elseif inList(key, {"giveitem", "give item", "gi"}) then
				for itemGuid, item in next, guildStore:raw() do
					if item.itemName == value then
						itemData.giveItem = itemGuid
						break
					end
				end

				return false

			elseif inList(key, {"givereply", "give reply", "reply", "gre"}) then
				itemData.giveReply = value

			elseif inList(key, {"reqrole", "requiredrole", "req role", "required role", "rr"}) then -- Required attributes
				local role = getRole(value, "name", lastData.guild)

				if not role then
					local text = parseFormat("${missingArg}: reqRole", langList)
					local embed = replyEmbed(text, data.message, "error")

					bird:post(nil, embed:raw(), data.channel)

					return false
				end

				itemData.reqRole = role.id

			elseif inList(key, {"reqcash", "requiredcash", "req cash", "required cash", "rc"}) then
				local value = realNum(value)

				if not value then
					local text = parseFormat("${missingArg}: reqCash", langList)
					local embed = replyEmbed(text, data.message, "error")

					bird:post(nil, embed:raw(), data.channel)

					return false
				end

				itemData.reqCash = value

			elseif inList(key, {"reqitem", "requireditem", "req item", "required item", "ri"}) then
				for itemGuid, item in next, guildStore:raw() do
					if item.itemName == value then
						itemData.reqItem = itemGuid
						break
					end
				end

				return false

			elseif inList(key, {"reqtime", "requiredtime", "time", "req time", "required time", "rt"}) then
				local value = interpTime(value)

				if not value then
					local text = parseFormat("${missingArg}: reqTime", langList)
					local embed = replyEmbed(text, data.message, "error")

					bird:post(nil, embed:raw(), data.channel)

					return false
				end

				itemData.reqTime = value

			elseif inList(key, {"takerole", "take role", "tr"}) then -- Attributes that will be taken
				local role = getRole(value, "name", lastData.guild)

				if not role then
					local text = parseFormat("${missingArg}: takeRole", langList)
					local embed = replyEmbed(text, data.message, "error")

					bird:post(nil, embed:raw(), data.channel)

					return false
				end

				itemData.takeRole = role.id

			elseif inList(key, {"takecash", "take cash", "tc"}) then
				local value = realNum(value)

				if not value then
					local text = parseFormat("${missingArg}: takeCash", langList)
					local embed = replyEmbed(text, data.message, "error")

					bird:post(nil, embed:raw(), data.channel)

					return false
				end

				itemData.takeCash = value

			elseif inList(key, {"takeitem", "take item", "ti"}) then
				for itemGuid, item in next, guildStore:raw() do
					if item.itemName == value then
						itemData.takeItem = itemGuid
						break
					end
				end

				return false
			end
		end
	end

	local function renderItemPreviewEmbed()
		local charLimit = 15
		local embed = newEmbed()

		embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		-- Base item-data
		local itemName = itemData.itemName
		itemName = itemName and parseFormat(itemName, langList) or "-"

		--[[if #itemName > charLimit then
			itemName = format("%s...", itemName:sub(1, charLimit))
		end]]

		embed:field({
			name = parseFormat("${storeItemName} (itemName)", langList),
			value = itemName or "-",
			inline = true,
		})

		local itemDesc = itemData.itemDesc
		itemDesc = itemDesc and parseFormat(itemDesc, langList) or "-"

		--[[if #itemDesc > charLimit then
			itemDesc = format("%s...", itemDesc:sub(1, charLimit))
		end]]

		embed:field({
			name = parseFormat("${storeItemDesc} (itemDesc)", langList),
			value = itemDesc or "-",
			inline = true,
		})

		embed:field({
			name = parseFormat("${storeItemPrice} (itemPrice)", langList),
			value = affixNum(itemData.itemPrice) or "-",
			inline = true,
		})

		local itemStock = itemData.itemStock

		if itemStock == -1 then
			itemStock = "♾️"
		else
			itemStock = affixNum(itemStock) or "-"
		end

		embed:field({
			name = parseFormat("${storeItemStock} (itemStock)", langList),
			value = itemStock or "-",
			inline = true,
		})

		-- Attributes that will be given
		local giveRole = getRole(itemData.giveRole, "id", lastData.guild)

		embed:field({
			name = parseFormat("${storeItemAwardRole} (giveRole)", langList),
			value = giveRole and giveRole.name or "-",
			inline = true,
		})

		embed:field({
			name = parseFormat("${storeItemAwardCash} (giveCash)", langList),
			value = affixNum(itemData.giveCash) or "-",
			inline = true,
		})

		embed:field({
			name = parseFormat("${storeItemAwardItem} (giveItem)", langList),
			value = itemData.giveItem or "-",
			inline = true,
		})

		local giveReply = itemData.giveReply
		giveReply = giveReply and parseFormat(giveReply, langList) or "-"

		--[[if #giveReply > charLimit then
			giveReply = format("%s...", giveReply:sub(1, charLimit))
		end]]

		embed:field({
			name = parseFormat("${storeItemReplyUsed} (giveReply)", langList),
			value = giveReply or "-",
			inline = true,
		})

		-- Required attributes
		local reqRole = getRole(itemData.reqRole, "id", lastData.guild)

		embed:field({
			name = parseFormat("${storeItemRequiredRole} (reqRole)", langList),
			value = reqRole and reqRole.name or "-",
			inline = true,
		})

		embed:field({
			name = parseFormat("${storeItemRequiredCash} (reqCash)", langList),
			value = affixNum(itemData.reqCash) or "-",
			inline = true,
		})

		embed:field({
			name = parseFormat("${storeItemRequiredItem} (reqItem)", langList),
			value = itemData.reqItem or "-",
			inline = true,
		})

		embed:field({
			name = parseFormat("${storeItemRequiredTime} (reqTime)", langList),
			value = parseFormat(timeLong(itemData.reqTime), langList) or "-",
			inline = true,
		})

		-- Attributes that will be taken
		local takeRole = getRole(itemData.takeRole, "id", lastData.guild)

		embed:field({
			name = parseFormat("${storeItemTakeRole} (takeRole)", langList),
			value = takeRole and takeRole.name or "-",
			inline = true,
		})

		embed:field({
			name = parseFormat("${storeItemTakeCash} (takeCash)", langList),
			value = affixNum(itemData.takeCash) or "-",
			inline = true,
		})

		embed:field({
			name = parseFormat("${storeItemTakeItem} (takeItem)", langList),
			value = itemData.takeItem or "-",
			inline = true,
		})

		return embed
	end

	if decoyBird == nil then
		local embed = renderItemPreviewEmbed()

		decoyBird = bird:post(nil, embed:raw(), lastData.channel)
		storeTempData[data.author.id].decoyBird = decoyBird

		return true
	else
		local embed = renderItemPreviewEmbed()

		decoyBird:update(nil, embed:raw())

		return true
	end
end

return {config = _config, func = _function}
