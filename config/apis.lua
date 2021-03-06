config.apiPoints = {
	catImage = "https://aws.random.cat/meow",
	dogImage = "https://dog.ceo/api/breeds/image/random",
	youtubeSearch = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&type=video&key=%s&q=%s",
	googleSearch = "https://www.googleapis.com/customsearch/v1?key=%s&cx=%s&q=%s",
	googleSearchImage = "https://www.googleapis.com/customsearch/v1?key=%s&cx=%s&searchType=image&q=%s",
	googleTranslate = "https://translation.googleapis.com/language/translate/v2?key=%s&target=%s&format=text&q=%s",
	googleTranslateLangs = "https://translation.googleapis.com/language/translate/v2/languages?key=%s&target=%s",
	discordScreenshare = "https://discordapp.com/channels/%s/%s",
	exchangeRate = "https://api.exchangeratesapi.io/latest?base=%s",
	wikipedia = "https://%s.wikipedia.org/w/api.php?action=opensearch&search=%s&limit=50&format=json",
	smartIp = "https://api.smartip.io/%s?api_key=%s",
	asciiMake = "http://artii.herokuapp.com/make?text=%s&font=%s",
	asciiList = "http://artii.herokuapp.com/fonts_list",

	robloxGetUserHeadShot = "https://www.roblox.com/search/users/avatar?isHeadshot=%s&userIds=%s",
	robloxGetUserFriends = "https://www.roblox.com/users/friends/list-json?friendsType=AllFriends&pageSize=%s&userId=%s",
	robloxGetUserFollowings = "https://www.roblox.com/users/friends/list-json?friendsType=Following&pageSize=%s&userId=%s",
	robloxGetUserFollowers = "https://www.roblox.com/users/friends/list-json?friendsType=Followers&pageSize=%s&userId=%s",
	robloxGetUserProfile = "https://www.roblox.com/users/%s/profile",
	robloxGetUserCollectibles = "https://inventory.roblox.com/v1/users/%s/assets/collectibles?sortOrder=Desc&limit=%s&cursor=%s",
	robloxGetUserAccessories = "https://inventory.roblox.com/v2/users/%s/inventory/%s?sortOrder=Desc&limit=%s&cursor=%s",
	robloxGetUserPrimaryGroup = "https://groups.roblox.com/v1/users/%s/groups/primary/role",

	robloxGetUserAvatar = "https://avatar.roblox.com/v1/users/%s/avatar", -- User ID
	robloxGetUserFromId = "https://api.roblox.com/users/%s", -- User ID
	robloxGetUserFromName = "https://api.roblox.com/users/get-by-username?username=%s", -- Username
	robloxGetUserAssetsWearing = "https://avatar.roblox.com/v1/users/%s/currently-wearing", -- User ID
	robloxGetUserOutfits = "https://avatar.roblox.com/v1/users/%s/outfits", -- User ID
	robloxGetUserOutfitInfo = "https://avatar.roblox.com/v1/outfits/117031959/details", -- Outfit ID

	robloxCatalogCategories = "https://catalog.roblox.com/v1/categories", -- No params
	robloxCatalogSubcategories = "https://catalog.roblox.com/v1/subcategories", -- No params
}

--[[ -- 110839429
https://api.roblox.com/docs?useConsolidatedPage=true


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


config.apiKeys = {
	youtubeVideoKey = "AIzaSyApllT_5QSRx-JnNJF8TNcDZRSSKm3cBCE",
	googleSearchKey = "AIzaSyDENwT8E_qHRpzrI6eLHANOAvLHy_WiyBo",
	googleSearchCx = "000898645152450243880:ypizs90acrv",
	googleTranslateKey = "AIzaSyDYrXTvbJhfINQg9zcXy_SuL4rpt5B1azs",
	googleImageSearchKey = "AIzaSyArQjPOLUHy-vVRndP4N57AMRr9xiRam1g",
	smartIpKey = "e4e5b09e-8550-4ac3-a1ec-9111e95b3886",
}
