local _config = {
	name = "edititem",
	desc = "${editsStoreItem}",
	usage = "${keyKey} = ${valueKey}",
	aliases = {"ei", "itemedit"},
	cooldown = 0,
	level = 3,
	direct = false,
}

local _function = function(data)
	local private = data.member == nil
	local guildData = data.guildData
	local guildLang = data.guildLang
	local args = data.args

	storeTempData = storeTempData or {}

	local sentence = data.content:sub(#args[1] + 2)
	local edit = storeTempData[data.user.id]

	local lastData = data
	local itemData
	local decoy

	local guildEconomy = getGuildEconomy(lastData.guild.id)
	local guildStore = guildEconomy:get("store", {})

	if edit then
		lastData = edit.data
		itemData = edit.itemData
		tempData = edit.tempData
		decoy = edit.decoy

		if inList(args[2], config.terms.cancel) then
			storeTempData[data.user.id] = nil

			local text = localize("${newItemCanceled}", guildLang)
			local embed = replyEmbed(text, data.message, "info")

			decoy:update(nil, embed:raw())
			return true

		elseif inList(args[2], config.terms.done) then
			local missingValues = ""

			for key, value in next, tempData do
				if value.required == true then
					if not itemData[key] then
						if missingValues ~= "" then
							missingValues = string.format("%s, ", missingValues)
						end

						missingValues = string.format("%s%s", missingValues, key)
					end
				end
			end

			if missingValues ~= "" then
				local text = localize("${newItemMissing}", guildLang, missingValues)
				local embed = replyEmbed(text, data.message, "warn")

				bird:post(nil, embed:raw(), data.channel)

				return false
			end

			storeTempData[data.user.id] = nil

			local guildEconomy = getGuildEconomy(lastData.guild.id)
			local guildStore = guildEconomy:get("store", {})

			local text = localize("${newItemCreated}", guildLang)
			local embed = replyEmbed(text, data.message, "ok")
			local guid = itemData.guid

			decoy:update(nil, embed:raw())
			guildStore:set(guid, itemData)
			return true
		end

		if lastData.guild.id ~= data.guild.id then
			local finishCommand = string.format("%s cancel", data.command)
			local editLostMessage = localize("${userItemEditLost} ${itemFinishTip2}", guildLang, data.user.username, finishCommand)
			local jumpTo = localize("[${jumpToMessage}](%s)", guildLang, decoy.message.link)
			local embed = enrich()

			embed:description(string.format("%s\n\n%s", editLostMessage, jumpTo))
			embed:color(paint.info)
			embed:footerIcon(config.images.info)
			signFooter(embed, lastData.author, guildLang)

			bird:post(nil, embed:raw(), data.channel)
			return false
		end
	else
		local item = getStoreItem(sentence, data.guild)

		if not item then
			local text = localize("${itemNotFoundName}", guildLang)
			local embed = replyEmbed(text, data.message, "warn")

			bird:post(nil, embed:raw(), data.channel)
			return false
		end

		lastData = data
		itemData = {}
		tempData = {
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
			giveReply = {
				required = false,
				default = "${inventoryItemUsed}",
				title = "$<storeItemReplyUsed>",
			},

			reqRole = {
				required = false,
				default = "",
				title = "$<storeItemRequiredRole>",
			},
		}

		for key, value in next, item do
			itemData[key] = value
		end

		for _, fill in next, {"itemDesc", "itemPrice", "itemStock", "giveReply"} do
			local fillData = tempData[fill]

			if fillData and not itemData[fill] then
				itemData[fill] = fillData.default
			end
		end

		storeTempData[data.author.id] = {
			data = data,
			itemData = itemData,
			tempData = tempData,
			decoy = decoy
		}
	end

	if sentence:match(config.patterns.keyValue.base) then
		for _, text in next, sentence:split("&&")
		do
			local key, value = text:match(config.patterns.keyValue.capture)

			key = key:lower()

			if inList(key, {"name", "itemname", "item name", "n"}) then -- Base item-data
				for itemGuid, item in next, guildStore:raw() do
					if item.itemName:lower() == value:lower() then
						local text = localize("${itemNameSpecifiedExists}: %s", guildLang, item.itemName)
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
					local text = localize("${missingArg}: itemPrice", guildLang)
					local embed = replyEmbed(text, data.message, "error")

					bird:post(nil, embed:raw(), data.channel)
					return false
				end

				itemData.itemPrice = math.floor(math.max(0, price))

			elseif inList(key, {"stock", "itemstock", "item stock", "s"}) then
				local stock = realNum(value)

				if not stock then
					local text = localize("${missingArg}: itemStock", guildLang)
					local embed = replyEmbed(text, data.message, "error")

					bird:post(nil, embed:raw(), data.channel)
					return false
				end

				itemData.itemStock = math.floor(math.max(-1, stock))

			elseif inList(key, {"giverole", "give role", "gr"}) then -- Attributes that will be given
				local role = getRole(value, "name", lastData.guild)

				if not role then
					local text = localize("${missingArg}: giveRole", guildLang)
					local embed = replyEmbed(text, data.message, "error")

					bird:post(nil, embed:raw(), data.channel)
					return false
				end

				itemData.giveRole = role.id

			elseif inList(key, {"givecash", "give cash", "gc"}) then
				value = realNum(value)

				if not value then
					local text = localize("${missingArg}: giveCash", guildLang)
					local embed = replyEmbed(text, data.message, "error")

					bird:post(nil, embed:raw(), data.channel)
					return false
				end

				itemData.giveCash = math.floor(value)

			elseif inList(key, {"reqrole", "requiredrole", "req role", "required role", "rr"}) then
				local role = getRole(value, "name", lastData.guild)

				if not role then
					local text = localize("${missingArg}: reqRole", guildLang)
					local embed = replyEmbed(text, data.message, "error")

					bird:post(nil, embed:raw(), data.channel)
					return false
				end

				itemData.reqRole = role.id
			end
		end
	end

	local function renderItemPreviewEmbed()
		local charLimit = 15
		local embed = enrich()

		embed:color(paint.info)
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		-- Base item-data
		local itemName = itemData.itemName
		itemName = itemName and localize(itemName, guildLang) or "-"

		--[[if #itemName > charLimit then
			itemName = string.format("%s...", itemName:sub(1, charLimit))
		end]]

		embed:field({
			name = localize("${storeItemName} (itemName)", guildLang),
			value = itemName or "-",
			inline = true,
		})

		local itemDesc = itemData.itemDesc
		itemDesc = itemDesc and localize(itemDesc, guildLang) or "-"

		--[[if #itemDesc > charLimit then
			itemDesc = string.format("%s...", itemDesc:sub(1, charLimit))
		end]]

		embed:field({
			name = localize("${storeItemDesc} (itemDesc)", guildLang),
			value = itemDesc or "-",
			inline = true,
		})

		embed:field({
			name = localize("${storeItemPrice} (itemPrice)", guildLang),
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
			name = localize("${storeItemStock} (itemStock)", guildLang),
			value = itemStock or "-",
			inline = true,
		})

		local giveRole = getRole(itemData.giveRole, "id", lastData.guild)

		embed:field({
			name = localize("${storeItemAwardRole} (giveRole)", guildLang),
			value = giveRole and giveRole.name or "-",
			inline = true,
		})

		embed:field({
			name = localize("${storeItemAwardCash} (giveCash)", guildLang),
			value = affixNum(itemData.giveCash) or "-",
			inline = true,
		})

		local reqRole = getRole(itemData.reqRole, "id", lastData.guild)

		embed:field({
			name = localize("${storeItemRequiredRole} (reqRole)", guildLang),
			value = reqRole and reqRole.name or "-",
			inline = true,
		})

		return embed
	end

	local finishCommand = string.format("%s done", data.command)
	local cancelCommand = string.format("%s cancel", data.command)
	local tipText = localize("${editModeResult}; ${itemFinishTip}", guildLang, data.author.tag, finishCommand, cancelCommand)

	if decoy == nil then
		local embed = renderItemPreviewEmbed()

		decoy = bird:post(tipText, embed:raw(), lastData.channel)
		storeTempData[data.author.id].decoy = decoy

		return true
	else
		local embed = renderItemPreviewEmbed()

		decoy:update(tipText, embed:raw())

		return true
	end
end

return {config = _config, func = _function}
