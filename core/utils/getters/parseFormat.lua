function parseFormat(text, list, ...)
	assert(text and type(text) == "string", "Must provide a text")
	assert(list and type(list) == "table", "Must provide a replacement list")

	local replace = {
		["($%b{})"] = function(text) return text end,
		["($%b<>)"] = function(text) return string.lower(text) end,
		["($%b[])"] = function(text) return string.upper(text) end,
	}

	for pattern, callback in next, replace do
		if text:find(pattern) then
			text = parseText(text, pattern, list, callback)
		end
	end

	if #{...} > 0 then
		return text:format(...)
	else
		return text
	end
end

return parseFormat
