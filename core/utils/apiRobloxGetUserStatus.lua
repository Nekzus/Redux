--[[
local link = "https://www.roblox.com/users/110839429/profile"
local data, request = http.request("GET", link)
local start = request:match("data%-statustext=(".-")%s%a")
]]

function apiRobloxGetUserStatus(id)
	local data, request = httpGet("robloxGetUserProfile", {id})

	if not request then
		print("Unable to decode apiRobloxGetUserStatus()")

		return nil
	end

	local decode = request:match(config.patterns.rbUserStatus.capture)

	return decode
end

return apiRobloxGetUserStatus
