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
	local edit = storeTempData[data.user.id]

	local lastData
	local filled
	local template
	local embed
	local decoyBird

	if edit then
		lastData = edit.data
		filled = edit.filled
		template = edit.template
		embed = edit.embed
		decoyBird = edit.decoyBird
	else
		filled = {}
		template = {
			-- Base definition of the current item
			itemName = {
				required = true,
				default = "${noNameSpecified}",
				title = "$<storeItemName>",
				short = "name",
			},
			itemDesc = {
				required = false,
				default = "${noDescSpecified}",
				title = "$<storeItemDesc>",
				short = "desc",
			},
			itemPrice = {
				required = true,
				default = 0,
				title = "$<storeItemPrice>",
				short = "price",
			},
			itemStock = {
				required = false,
				default = 0,
				title = "$<storeItemStock>",
				short = "stock",
			},

			-- Awards that will be granted once the current item is utilized
			giveRole = {
				required = false,
				default = 0,
				title = "$<storeItemAwardRole>",
				short = "give role",
			},
			giveCash = {
				required = false,
				default = 0,
				title = "$<storeItemAwardCash>",
				short = "give cash",
			},
			giveItem = {
				required = false,
				default = "",
				title = "$<storeItemAwardItem>",
				short = "give item",
			},
			giveReply = {
				required = true,
				default = "${inventoryItemUsed}",
				title = "$<storeItemReplyUsed>",
				short = "reply",
			},

			-- Required items that will not be consumed but must be present to
			-- allow the usage of the current item
			reqRole = {
				required = false,
				default = 0,
				title = "$<storeItemRequiredRole>",
				short = "need role",
			},
			reqCash = {
				required = false,
				default = 0,
				title = "$<storeItemRequiredCash>",
				short = "need cash",
			},
			reqItem = {
				required = false,
				default = 0,
				title = "$<storeItemRequiredItem>",
				short = "need item",
			},
			reqTime = {
				required = false,
				default = 0,
				title = "$<storeItemRequiredTime>",
				short = "need time",
			},

			-- These will be taken from the user upon the usage
			takeRole = {
				required = false,
				default = 0,
				title = "$<storeItemTakeRole>",
				short = "need role",
			},
			takeCash = {
				required = false,
				default = 0,
				title = "$<storeItemTakeCash>",
				short = "need cash",
			},
			takeItem = {
				required = false,
				default = 0,
				title = "$<storeItemTakeItem>",
				short = "need item",
			},
		}

		for _, auto in next, {"itemDesc", "giveReply"} do
			local templateData = template[auto]

			if templateData then
				filled[auto] = templateData
			else
				printf("Template data not found for %s", auto)
			end
		end

		embed = newEmbed()

		embed:color(config.colors.blue:match(config.patterns.colorRGB.capture))
		embed:footerIcon(config.images.info)
		signFooter(embed, data.author, guildLang)

		decoyBird = bird:post(nil, embed:raw(), data.channel)

		storeTempData[data.author.id] = {
			data = data,
			filled = filled,
			template = template,
			embed = embed,
			decoyBird = decoyBird
		}
	end

	-- now onto logic, make it so it will skip all above if there's already a registered request
	-- with all matching data
end

return {config = _config, func = _function}
