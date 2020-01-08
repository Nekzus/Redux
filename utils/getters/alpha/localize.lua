local replace = {
	["($%b{})"] = function(text)
		return text
	end,

	["($%b<>)"] = function(text)
		return string.lower(text)
	end,

	["($%b[])"] = function(text)
		return string.upper(text)
	end,

	["($%b^^)"] = function(text)
		return text:gsub("%a", function(c)
			return math.random(1, 2) == 1
			and c:upper()
			or c:lower()
		end)
	end
}

function localize(text, lang, ...)
	assert(text and type(text) == "string", "Must provide a string")
	assert(lang and type(lang) == "string", "Must provide a language key")

	local args = {...}

	for pattern, callback in next, replace do
		if text:find(pattern) then
			text = text:gsub(pattern,
				function(word)
					local value = langs[word:sub(3, -2)]
					value = value and value[lang] or word

					return (callback and callback(value)) or value
				end
			)
		end
	end

	return (#args > 0 and string.format(text, unpack(args))) or text
end

return localize
