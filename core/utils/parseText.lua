function parseText(text, pattern, list, callback)
	return (text:gsub(pattern,
		function(word)
		if callback then
			return callback(list[word:sub(3, - 2)] or word)
		else
			return list[word:sub(3, - 2)] or word
		end
	end))
end

return parseText
