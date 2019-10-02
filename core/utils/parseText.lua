function parseText(text, pattern, list, f)
	return (text:gsub(pattern,
		function(word)
		if f then
			return f(list[word:sub(3, - 2)] or word)
		else
			return list[word:sub(3, - 2)] or word
		end
	end))
end

return parseText
