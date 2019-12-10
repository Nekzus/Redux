local function filterList(list)
	local result = {}

	for i = 1, #list[2] do
		local valid = true
		local packed = {
			result = list[2][i],
			definition = list[3][i],
			link = list[4][i]
		}

		for _, item in next, packed do
			if item == nil or item == "" then
				valid = false
				break
			end
		end

		if valid then
			insert(result, packed)
		end
	end

	return result
end


function apiWiki(text, lang)
	local data, request = httpGet("wikipedia", {lang or "en", text})
	local decode = json.decode(request)

	if not decode then
		print("Unable to decode apiWiki()")

		return nil
	end

	return filterList(decode)
end

return apiWiki
