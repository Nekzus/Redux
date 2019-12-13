function isFiltered(text, list)
	local result = {}

	text = text:lower()

	for _, word in next, list do
		local found = text:find(word:lower())

		if found then
			table.insert(result, found)
		end
	end

	if #result == 0 then
		return false
	else
		return result
	end
end

return isFiltered
