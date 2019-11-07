langs = langs or {}

langs["en-us"] = {
	-- Words
	["commands"] = "Commands",
	["page"] = "Page",
	["name"] = "Name",
	["type"] = "Type",
	["nativeName"] = "Native Name",
	["symbol"] = "Symbol",
	["code"] = "Code",
	["discrim"] = "Discriminator",
	["id"] = "ID",
	["status"] = "Status",
	["joinedDisc"] = "Joined Discord",
	["joinedServer"] = "Joined Server",
	["created"] = "Created",
	["members"] = "Members",
	["categories"] = "Categories",
	["textChannels"] = "Text Channels",
	["voiceChannels"] = "Voice Channels",
	["roles"] = "Roles",
	["emojis"] = "Emojis",
	["moderation"] = "Moderation",
	["fun"] = "Fun",
	["base"] = "Base",
	["owner"] = "Owner",
	["pong"] = "Pong",
	["main"] = "Primary",
	["initial"] = "Initial",
	["patron"] = "Patron",
	["patrons"] = "Patrons",
	["level"] = "Level",
	["economy"] = "Economy",
	["role"] = "Role",
	["cash"] = "Cash",
	["bank"] = "Bank",
	["networth"] = "Networth",
	["alias"] = "Alias",
	["aliases"] = "Aliases",
	["none"] = "None",
	["command"] = "Command",
	["usage"] = "Usage",
	["params"] = "Parameters",
	["store"] = "Store",
	["soon"] = "Soon",
	["no"] = "No",
	["nope"] = "Nope",
	["yes"] = "Yes",
	["yep"] = "Yep",
	["maybe"] = "Maybe",
	["question"] = "Question",
	["answer"] = "Answer",
	["googleSearch"] = "Google Search",
	["translation"] = "Translation",
	["sourceLanguage"] = "Source Language",
	["translationCodes"] = "Translation Codes",
	["guilds"] = "Guilds",
	["urbanDictionary"] = "Urban Dictionary",
	["rating"] = "Rating",
	["example"] = "Example",

	["inventory"] = "Inventory",
	["social"] = "Social",
	["friends"] = "Friends",
	["following"] = "Following",
	["followers"] = "Followers",
	["investments"] = "Investments",
	["recentAveragePrice"] = "Recent Average Price",
	["recentAveragePriceTag"] = "RAP",
	["limiteds"] = "Limiteds",
	["userVisits"] = "User Visits",

	["itemName"] = "Item Name",
	["itemDesc"] = "Item Description",
	["itemPrice"] = "Item Price",
	["stockQuant"] = "Stock Quantity",
	["roleAward"] = "Role to Award",

	["day"] = "Day",
	["days"] = "Days",
	["hour"] = "Hour",
	["hours"] = "Hours",
	["minute"] = "Minute",
	["minutes"] = "Minutes",
	["second"] = "Second",
	["seconds"] = "Seconds",

	["dev"] = "Developer",
	["svOwner"] = "Owner",
	["org"] = "Organizer",
	["admin"] = "Administrator",
	["mod"] = "Moderator",
	["user"] = "User",
	["member"] = "Member",
	["muted"] = "Muted",

	-- Permissions
	["addReactions"] = "Add Reactions",
	["administrator"] = "Administrator",
	["attachFiles"] = "Attach Files",
	["banMembers"] = "Ban Members",
	["changeNickname"] = "Change Nickname",
	["connect"] = "Connect to Voice-Chat",
	["createInstantInvite"] = "Create Instant Invite",
	["deafenMembers"] = "Deafen Members",
	["embedLinks"] = "Embed Links",
	["kickMembers"] = "Kick Members",
	["manageChannels"] = "Manage Channels",
	["manageEmojis"] = "Manage Emojis",
	["manageGuild"] = "Manage Guild",
	["manageMessages"] = "Manage Messages",
	["manageNicknames"] = "Manage Nicknames",
	["manageRoles"] = "Manage Roles",
	["manageWebhooks"] = "Manage Webhooks",
	["mentionEveryone"] = "Mention Everyone",
	["moveMembers"] = "Move Members",
	["muteMembers"] = "Mute Members",
	["prioritySpeaker"] = "Priority Speaker",
	["readMessageHistory"] = "Read Message History",
	["readMessages"] = "Read Messages",
	["sendMessages"] = "Send Messages",
	["sendTextToSpeech"] = "Send Text-to-Speech",
	["speak"] = "Speak in Voice-Chat",
	["useExternalEmojis"] = "Use External Emojis",
	["useVoiceActivity"] = "Use Voice-Activity",
	["viewAuditLog"] = "View Audit Log",

	["mutedUsers"] = "Muted Users",
	["duration"] = "Duration",
	["reason"] = "Reason",
	["timeLeft"] = "Time Left",

	["security"] = "Security",
	["geo"] = "Geolocation",
	["latitude"] = "Latitude",
	["longitude"] = "Longitude",
	["zipCode"] = "ZIP Code",
	["timezone"] = "Timezone",
	["asn"] = "ASN",
	["gmtOffset"] = "GMT Offset",
	["dateTime"] = "Date and Time",
	["microsoftName"] = "Microsoft Name",
	["iana"] = "IANA",
	["executionTime"] = "Execution Time",
	["error"] = "Error",
	["hostName"] = "Host Name",
	["ipType"] = "IP Type",
	["requesterIp"] = "Requester IP",
	["ip"] = "IP",

	["isMetric"] = "Is Metric",
	["isInEurope"] = "Is In Europe",
	["isDaylightSaving"] = "Is Daylight Saving",
	["isCrawler"] = "Is Crawler",
	["isProxy"] = "Is Proxy",
	["isTor"] = "Is Tor",

	["countryGeoId"] = "Country Geo ID",
	["regionGeoId"] = "Region Geo ID",
	["continentGeoId"] = "Continent Geo ID",

	["city"] = "City",
	["country"] = "Country",
	["capital"] = "Capital",

	["regionCode"] = "Region Code",
	["regionName"] = "Region Name",
	["continentCode"] = "Continent Code",
	["continentName"] = "Continent Name",
	["countryName"] = "Country Name",

	["countryISOCode"] = "Country ISO Code",
	["countryTwoLetterISOCode"] = "Country Two-Letter ISO Code",

	-- Keys
	["pageKey"] = "[page]",
	["userKey"] = "[user]",
	["emoteKey"] = "[emote]",
	["messageKey"] = "[message]",
	["equationKey"] = "[equation]",
	["keyKey"] = "[key]",
	["valueKey"] = "[value]",
	["codeKey"] = "[code]",
	["nameKey"] = "[name]",
	["numKey"] = "[number]",
	["languageKey"] = "[language]",
	["reasonKey"] = "[reason]",

	-- Outputs
	["unicodeResult"] = "Unicode: \\%s",
	["inputResult"] = "Input: ",
	["outputResult"] = "Output: ",
	["editModeResult"] = "Being edited by **%s**",
	["embedFinishTip"] = "Say `%s` once finished to fully create the embed",
	["embedFinishTip2"] = "You can say `%s` to end your embed from here",
	["itemFinishTip"] = "Say `%s` to finish your item, or `%s` to cancel",
	["itemFinishTip2"] = "You can say `%s` to end your item from here",
	["roleAndAbove"] = "%s and above",
	["nextInstruction"] = "Choose the **%s** (%s %s)",
	["storeBuyTip"] = "Use `%s` to purchase an item from the store",
	["storeInfoTip"] = "Use `%s` to see more details about an item from the store",
	["clickHereScreenshare"] = "Click here to enable Screenshare",

	-- Links
	["howToMeme"] = "[Click here to see the full list of memes](https://imgflip.com/memegenerator)",

	-- Phrases
	["missingArg"] = "Missing argument",
	["noReason"] = "No reason provided.",
	["userNotFound"] = "User not found",
	["executeFromGuild"] = "Can only execute this command from a guild",
	["mentionedHigher"] = "Mentioned user has a role higher than you or the bot",
	["specifyUser"] = "Please, specify an user",
	["noExecuteOwner"] = "Cannot execute this command on the guild owner",
	["noExecuteBot"] = "Cannot execute this command on the bot",
	["noExecuteSelf"] = "Cannot execute this command on yourself",
	["roleNotFound"] = "`@%s` role not found",
	["luaNotSupported"] = "Running this type of command is not supported",
	["linksNotSupported"] = "Links are not supported for this command",
	["noAllowEdit"] = "You are not allowed to modify this configuration",
	["guildDataNotFound"] = "Guild data not found",
	["muteRoleNotFound"] = "`Muted` role not found",
	["modRoleNotFound"] = "`Moderator` role not found",
	["adminRoleNotFound"] = "`Administrator` role not found",
	["orgRoleNotFound"] = "`Organizer` role not found",
	["noPerm"] = "Insufficient permission",
	["commandCooldownFor"] = "Command in cooldown for **%s** more seconds!",
	["cashValueInvalid"] = "Invalid value for cash amount",
	["notAvailableLang"] = "Sorry, but this command is not supported for the selected language!",
	["noResults"] = "No results",
	["insufficientFunds"] = "Insufficient funds",
	["patronsOnlyCommand"] = "Only patrons have access to this command!",
	["commandNotFound"] = "Command '%s' not found",
	["noPromoteEqual"] = "You cannot promote that user to your role",
	["noDemoteEqual"] = "You cannot demote that user because you have the same role",
	["cannotPromoteUser"] = "**%s** cannot be promoted",
	["cannotDemoteUser"] = "**%s** cannot be demoted",
	["botDesc"] = "%s is a multi-purpose bot designed to help moderate your server.",
	["commandRanBy"] = "Command ran by %s",
	["userBanned"] = "**%s** has been banned",
	["userUnbanned"] = "**%s** has been unbanned",
	["usersUnbanned"] = "**%s** users have been unbanned",
	["userKicked"] = "**%s** has been kicked",
	["userUnmuted"] = "**%s** has been unmuted",
	["userModed"] = "**%s** has been given the `Moderator` role",
	["userUnmoded"] = "**%s** had the `Moderator` role taken away",
	["userAdmined"] = "**%s** has been given the `Administrator` role",
	["userUnadmined"] = "**%s** had the `Administrator` role taken away",
	["userOrganizered"] = "**%s** has been given the `Organizer` role",
	["userUnorged"] = "**%s** had the `Organizer` role taken away",
	["beenDefined"] = "**%s** has been defined as **%s**",
	["botDataSaved"] = "Bot data has been saved",
	["roleAddedMod"] = "Role `@%s` has been added as `Moderator`",
	["roleRemovedMod"] = "Role `@%s` has been removed as a `Moderator`",
	["roleAddedAdmin"] = "Role `@%s` has been added as `Administrator`",
	["roleRemovedAdmin"] = "Role `@%s` has been removed as a `Administrator`",
	["roleAddedOrganizer"] = "Role `@%s` has been added as `Organizer`",
	["roleRemovedOrganizer"] = "Role `@%s` has been removed as a `Organizer`",
	["roleAddedMuted"] = "Role `@%s` has been added as `Muted`",
	["roleRemovedMuted"] = "Role `@%s` has been removed as a `Muted`",
	["mutedRoleTip"] = "Don't forget to set a `Muted` role with **%ssetmute**",
	["modRoleTip"] = "Don't forget to set a `Moderator` role with **%ssetmod**",
	["adminRoleTip"] = "Don't forget to set a `Administrator` role with **%ssetadmin**",
	["orgRoleTip"] = "Don't forget to set a `Organizer` role with **%ssetorg**",
	["alreadyPatron"] = "**%s** is already a patron",
	["notPatron"] = "**%s** is not a patron",
	["patronAdded"] = "**%s** is now a patron",
	["patronRemoved"] = "**%s** is no longer a patron",
	["cashSetSuccessful"] = "Cash for **%s** has been set to **%s**",
	["bankSetSuccessful"] = "Bank for **%s** has been set to **%s**",
	["netSetSuccessful"] = "Networth for **%s** has been set to **%s**",
	["serverEconomyReset"] = "Server economy has been reset",
	["cashWithdrawn"] = "You've withdrawn **%s** from your bank!",
	["cashDeposited"] = "You've deposited **%s** into your bank!",
	["currentBankAmount"] = "You currently have **%s** in your bank",
	["currentCashAmount"] = "You currently have **%s** in cash",
	["usernameSet"] = "Username has been set to '**%s**'",
	["usernameFailed"] = "Failed to set username to '**%s**'",
	["playingStatusSet"] = "Playing status has been set to '**%s**'",
	["playingStatusFailed"] = "Failed to set playing status to '**%s**'",
	["roleSelectedHigher"] = "Please, make sure that the bot has a role above **%s**",
	["userPromoted"] = "**%s** has been promoted to **%s**",
	["userDemoted"] = "**%s** has been demoted to **%s**",
	["notEnoughCash"] = "You don't have enough cash for that",
	["userPaidSuccess"] = "You have paid **%s** to **%s**",
	["userCashTaken"] = "You have taken **%s** from **%s**",
	["userCashGiven"] = "You gave **%s** to **%s**",
	["neksInvite"] = "%s",
	["invalidAmount"] = "Invalid amount",
	["beenKicked"] = "You have been kicked from **%s**; Moderator note: %s",
	["beenBanned"] = "You have been banned from **%s** and may not rejoin until you are unbanned; Moderator note: %s",
	["beenMuted"] = "You have been muted in **%s**; Moderator note: %s",
	["botModulesReloaded"] = "All modules have been reloaded successfully!",
	["noExecuteOtherBot"] = "You cannot execute this command in other bots",
	["messageWithTermsNotFound"] = "Message with terms '%s' not found",
	["messageSentBy"] = "Message sent by %s",
	["jumpToMessage"] = "Jump to message",
	["alreadyMuted"] = "**%s** is already muted!",
	["videoNotFoundTerms"] = "Video not found for terms '%s'",
	["langNotFound"] = "Language **%s** not found!",
	["patronLevelSet"] = "**%s** had his patron level set to **%s**",
	["userEmbedEditLost"] = "**%s**, it seems like you already have an active embed being edited.",
	["couldNotProcess"] = "Could not process the request",
	["cannotDeleteMoreThanXMessages"] = "Cannot delete more than **%s** messages at once.",
	["defaultAmountSetTo"] = "Default amount has been set to: **%s**",
	["startingIn"] = "Starting in **%ss**...",
	["failedContinueDetails"] = "Failed to continue: %s",
	["successDeletedXMessages"] = "Successfully deleted **%s** messages from this channel.",
	["deletedCurrentXMessages"] = "Messages deleted so far: **%s**",
	["userItemEditLost"] = "**%s**, it seems like you already have an active item being edited.",
	["noNameSpecified"] = "No nome specified.",
	["noDescSpecified"] = "No description specified.",
	["newItemCanceled"] = "Item creation canceled.",
	["newItemCreated"] = "Item created successfully.",
	["newItemMissing"] = "Cannot create item, you must specify: **%s**",
	["itemNameSpecifiedExists"] = "An item with the name that you've specified already exists",
	["inventoryItemUsed"] = "Item used!",
	["mustBeInGuildVoice"] = "You must be in a voice-channel in order for this to work!",
	["shareLinkForVoice"] = "Screenshare for channel: %s",
	["storeItemName"] = "Item name",
	["storeItemDesc"] = "Item description",
	["storeItemPrice"] = "Item price",
	["storeItemStock"] = "Item stock",
	["storeItemAwardRole"] = "Award role",
	["storeItemAwardCash"] = "Award cash",
	["storeItemRequiredRole"] = "Required role",
	["couldNotFindTerms"] = "Could not find anything with '%s'",
	["messageTooLong"] = "Your message is too long!",
	["googleTranslationNotFound"] = "Could not translate your message, try again later or with different terms!",
	["missingThesePerms"] = "In order to continue, I must be able to %s",
	["guildNotFound"] = "Guild not found!",
	["successLeftGuild"] = "Successfully left guild (**%s**)",
	["itemNotFoundName"] = "Item not found!",
	["itemDeletedFromStore"] = "Item successfully deleted from the store",
	["storeItemCashNeeded"] = "You're **%s** short from buying that item!",
	["storeItemOutStock"] = "This item has ran out of stock!",
	["stockItemBuyMax"] = "You can only buy **%s** editions of this item!",
	["successBoughtItem"] = "Item successfully bought!",
	["itemUseMustHaveRole"] = "You must have the **%s** role in order to use this item!",
	["itemDoesNotHave"] = "You don't have this item!",
	["successGaveItem"] = "Successfully gave the item!",

	["followingUserBeenMuted"] = "**%s** has been muted for **%s**",
	["followingUsersBeenMuted"] = "**%s** have been muted for **%s**",

	["followingUserCannotMute"] = "**%s** could not be muted",
	["followingUsersCannotMute"] = "**%s** could not be muted",

	["followingUserAlreadyMuted"] = "**%s** is already muted",
	["followingUsersAlreadyMuted"] = "**%s** are already muted",

	["followingUserBeenUnmuted"] = "**%s** has been unmuted",
	["followingUsersBeenUnmuted"] = "**%s** have been unmuted",

	["followingUserNotMuted"] = "**%s** is not muted",
	["followingUsersNotMuted"] = "**%s** are not muted",

	["peopleAgree"] = "People agree",
	["peopleDisagree"] = "People disagree",

	-- Discord Error Codes
	["discordError50034"] = "You can only bulk delete messages that are under 14 days old.",

	-- Descriptions
	["categoryDescBase"] = "main and essential.",
	["categoryDescEconomy"] = "economy and items.",
	["categoryDescFun"] = "fun and games.",
	["categoryDescModeration"] = "moderation tools.",

	["getsIpData"] = "gets information about an IP",
	["getsDefinition"] = "gets the definition for the word or phrase given.",
	["showsMutes"] = "shows the currently muted user or users.",
	["givesItemToSomeone"] = "gives the mentioned item to the mentioned person or more.",
	["showsRobloxProfile"] = "shows the ROBLOX profile of the mentioned user.",
	["searchesImage"] = "searches on google for the mentioned image.",
	["setsNsfwMode"] = "sets the NSFW mode for the channel you're in.",
	["usesItemFromInventory"] = "uses the mentioned item in your inventory.",
	["showsInventory"] = "shows your inventory.",
	["zappifiesText"] = "zappifies text.",
	["buysItemFromStore"] = "buys an item from the store.",
	["removesItemFromStore"] = "removes the mentioned item from the store.",
	["leavesMentionedGuild"] = "leaves the mentioned guild.",
	["showsGlobalGuildsList"] = "shows the global list of guilds that the bot is in.",
	["translatesYourText"] = "translates your text.",
	["emojifiesText"] = "turns your text into emojis.",
	["searchesGoogle"] = "searches on google for what you want.",
	["createsStoreItem"] = "creates a new item for the store of the server.",
	["createsScreenshare"] = "creates a screenshare link for your voice-channel.",
	["setsLang"] = "sets the default language.",
	["setsPrefix"] = "sets the default prefix.",
	["setsDelCmd"] = "sets whether to delete commands after being ran or not.",
	["purgesMessages"] = "bulk deletes the defined number of messages.",
	["answersYesNoMaybe"] = "says yes, no or maybe",
	["saysPong"] = "says pong!",
	["helpMessage"] = "shows a help message.",
	["showCat"] = "shows an image of a cat.",
	["showDog"] = "shows an image of a dog.",
	["bansUser"] = "bans the mentioned user.",
	["unbansUser"] = "unbans the mentioned user.",
	["kicksUser"] = "kicks the mentioned user.",
	["modsUser"] = "gives the mentioned user the `Moderator` role.",
	["unmodsUser"] = "removes from the mentioned user the `Moderator` role.",
	["adminsUser"] = "gives the mentioned user the `Administrator` role.",
	["unadminsUser"] = "removes from the mentioned user the `Administrator` role.",
	["orgsUser"] = "gives the mentioned user the `Organizer` role.",
	["unorgsUser"] = "removes from the mentioned user the `Organizer` role.",
	["showsEmote"] = "displays the unicode for an emote.",
	["mutesUser"] = "mutes the mentioned user.",
	["unmutesUser"] = "unmutes the mentioned user.",
	["botSays"] = "makes the bot say something.",
	["evalsMath"] = "evaluates a mathematical expression.",
	["constructsEmbed"] = "begins constructing an embed.",
	["returnsUserInfo"] = "returns basic information about an user.",
	["returnsServerInfo"] = "returns basic information about an user.",
	["allowsLua"] = "allows you to run Lua commands from the bot.",
	["setsGlobalConfig"] = "sets a global configuration.",
	["owoifiesText"] = "owoifies a text.",
	["savesBotDataAndEdit"] = "saves bot data and ends the application.",
	["setsBotGame"] = "sets the bot's playing status.",
	["updatesBotData"] = "forcefully updates the bot data.",
	["addsRoleMod"] = "gives `Moderator` permissions to the mentioned role.",
	["removesRoleMod"] = "removes `Moderator` permissions from the mentioned role.",
	["addsRoleAdmin"] = "gives `Administrator` permissions to the mentioned role.",
	["removesRoleAdmin"] = "removes `Administrator` permissions from the mentioned role.",
	["addsRoleOrganizer"] = "gives `Organizer` permissions to the mentioned role.",
	["removesRoleOrganizer"] = "removes `Organizer` permissions from the mentioned role.",
	["addsRoleMuted"] = "makes the mentioned role the main role for `Muted`.",
	["removesRoleMuted"] = "removes the mentioned role from being the `Muted` role.",
	["listsDefinedRoles"] = "lists the defined roles accordingly their permissions.",
	["addsPatron"] = "adds the mentioned user to the patrons list.",
	["listsPatrons"] = "shows the patrons list.",
	["listsEconomyTopUsers"] = "shows the top list for the economy ranking of this server.",
	["laranjosText"] = "laranjofies the text.",
	["withdrawsCash"] = "withdraws the specified amount from your bank.",
	["depositsCash"] = "deposits the specified amount of cash into your bank.",
	["promotesUser"] = "promotes the mentioned user to the next rank.",
	["demotesUser"] = "demotes the mentioned user to their previous rank.",
	["setsUsername"] = "sets the bot's username.",
	["checksBalance"] = "checks your cash and bank.",
	["worksForMoney"] = "works for money.",
	["commitsCrimeForMoney"] = "commits a crime for money.",
	["setsCashAmount"] = "sets the cash amount for the mentioned user.",
	["setsBankAmount"] = "sets the bank amount for the mentioned user.",
	["setsNetAmount"] = "sets the networth amount for the mentioned user.",
	["insultsSomeone"] = "insults someone.",
	["showsDadJoke"] = "shows a dad joke.",
	["chuckNorrisFact"] = "shows a fact about Chuck Norris.",
	["makesMeme"] = "makes a meme.",
	["paysSomeone"] = "gives someone the amount you specify.",
	["showsServerStore"] = "shows the store of your guild.",
	["invitesNekito"] = "shows Nekito's invite link.",
	["resetsServerEconomy"] = "resets the server economy.",
	["reloadsBotModules"] = "reloads all modules.",
	["teachesToGoogle"] = "googles something for lazy people.",
	["quotesMesage"] = "quotes a message in the chat.",
	["showsClan"] = "shows information about your clan.",
	["searchesYoutubeVideo"] = "searches for a youtube video.",

	-- Work command responses -- https://www.vocabulary.cl/Basic/Professions.htm
	["workedAsBartender"] = "You've worked as a bartender serving drinks all night and made **%s**",
	["workedAsDJ"] = "You've worked as DJ cheering a party all night and made **%s**",
	["workedAsUberDriver"] = "You've worked as a Uber driver taking people to everywhere and made **%s**",
	["workedAsAviator"] = "You've worked as a plane aviator taking people to their destinations and made **%s**",
	["workedAsProgrammer"] = "You've worked as a programmer in a community project and made **%s**",
	["workedAsArchitect"] = "You've worked as architect developing various houses and buildings and made **%s**",
	["workedAsBusDriver"] = "You've worked as a bus driver for all over the city and made **%s**",
	["workedAsButcher"] = "You've worked as a butcher cutting many meats and made **%s**",
	["workedAsElectrician"] = "You've worked as an electrician setting up some wires and made **%s**",
	["workedAsFarmer"] = "You've worked as a farmer taking care of cows, pigs and chickens and made **%s**",
	["workedAsFlorist"] = "You've worked as a florist taking care of many roses, sunflowers and other flowers and made **%s**",
	["workedAsDoctor"] = "You've worked as a doctor taking care of your patients in pain and other issues and made **%s**",
	["workedAsFisherman"] = "You've worked as a fisher fishing many rare fishes and letting go of the ones in extinction and made **%s**",
	["workedAsGardener"] = "You've worked as a gardener taking care of the garden of a very sweet lady and made **%s**",
	["workedAsHairdresser"] = "You've worked as a haircutter cutting the hair of every client that would enter your sallon and made **%s**",
	["workedAsLifeguard"] = "You've worked as a life-guard in a very populous beach during all day and made **%s**",
	["workedAsMechanic"] = "You've worked as a mechanic fixing various cars and bikes during all day and made **%s**",

	-- Crime command responses
	["commitCrimeCarTheft"] = "You're thinking about stealing a car..",
	["commitCrimeStealBag"] = "You're thinking about stealing a bag from someone..",
	["commitCrimeRobSomeone"] = "You've thinking about robbing someone..",
	["commitCrimeRobBank"] = "You've been invited to rob a bank..",
	["commitCrimeHeadhunt"] = "You've been contacted to work as a headhunter..",
	["commitCrimeRobStore"] = "You're thinking about robbing a store..",
	["commitCrimeKidnap"] = "You've been contacted to kidnap someone..",
	["commitCrimeRobBike"] = "You're thinking about robbing a bike..",
	["commitCrimeStealArmoredCar"] = "You've been invited to steal an armored car..",
	["commitCrimeAssassinatePolitician"] = "You've been contacted to assassinate a politician..",
	["commitCrimeHackBank"] = "You've been contacted to hack the database of a bank..",
	["commitCrimeStreetRace"] = "You've been contacted about a street race..",
	["commitCrimeStreetJewelry"] = "You're thinking about stealing a jewelry..",
}
