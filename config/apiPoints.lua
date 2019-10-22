config.apiPoints = {
	catImage = "https://aws.random.cat/meow",
	dogImage = "https://dog.ceo/api/breeds/image/random",
	youtubeSearch = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&order=date&type=video&key=%s&q=%s",
	googleSearch = "https://www.googleapis.com/customsearch/v1?key=%s&cx=%s&q=%s",
	googleTranslate = "https://translation.googleapis.com/language/translate/v2?key=%s&target=%s&q=%s",
	truthYesNo = "https://yesno.wtf/api",
	truthYesNoForce = "https://yesno.wtf/api?force=%s",
	discordScreenshare = "https://discordapp.com/channels/%s/%s",

	robloxGetUserHeadShot = "https://www.roblox.com/search/users/avatar?isHeadshot=false&userIds=%s",
	robloxGetUserFollowingCount = "https://www.roblox.com/users/friends/list-json?friendsType=Following&pageSize=100&userId=%s",
	robloxGetUserFollowersCount = "https://www.roblox.com/users/friends/list-json?friendsType=Followers&pageSize=100&userId=%s",

	robloxGetUserFromId = "https://api.roblox.com/users/%s", -- User ID
	robloxGetUserFromName = "https://api.roblox.com/users/get-by-username?username=%s", -- Username
	robloxGetUserFriendsList = "https://friends.roblox.com/v1/users/%s/friends", -- User ID
	robloxGetUserFriendsCount = "https://friends.roblox.com/v1/users/%s/friends/count", -- User ID
	robloxUserAvatar = "https://avatar.roblox.com/v1/users/%s/avatar", -- User ID
	robloxAssetsWearing = "https://avatar.roblox.com/v1/users/%s/currently-wearing", -- User ID
	robloxUserOutfits = "https://avatar.roblox.com/v1/users/%s/outfits", -- User ID
	robloxOutfitInfo = "https://avatar.roblox.com/v1/outfits/117031959/details", -- Outfit ID
	robloxCatalogCategories = "https://catalog.roblox.com/v1/categories", -- No params
	robloxCatalogSubcategories = "https://catalog.roblox.com/v1/subcategories", -- No params
	robloxCollectibles = "https://inventory.roblox.com/v1/users/%s/assets/collectibles?sortOrder=Desc&limit=100"
}

--[[ -- 110839429
https://accountsettings.roblox.com/docs
https://api.roblox.com/docs
https://auth.roblox.com/docs
https://avatar.roblox.com/docs
https://billing.roblox.com/docs
https://catalog.roblox.com/docs
https://chat.roblox.com/docs
https://develop.roblox.com/docs
https://friends.roblox.com/docs
https://games.roblox.com/docs
https://groups.roblox.com/docs
https://inventory.roblox.com/docs
https://notifications.roblox.com/docs
https://points.roblox.com/docs
https://presence.roblox.com/docs
https://developer.roblox.com/en-us/articles/Catalog-API
]]
