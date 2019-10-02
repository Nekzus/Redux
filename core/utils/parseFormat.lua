function parseFormat(text, list, ...)
	assert(text, "Must provide a text")
	assert(list, "Must provide a replacement list")

	local replace = {
		["($%b{})"] = function(text) return text end,
		["($%b<>)"] = function(text) return string.lower(text) end,
		["($%b[])"] = function(text) return string.upper(text) end,
	}

	for pattern, f in next, replace do
		if text:find(pattern) then
			text = parseText(text, pattern, list, f)
		end
	end

	return #{...} > 0 and text:format(...) or text
end

return parseFormat
