function getBytes(text)
	local result = ""

	for char in gmatch(text, "[%z\1-\127\194-\244][\128-\191]*") do
		local bytes = {byte(char, 1, - 1)}

		for _, charByte in next, bytes do
			result = format("%s[\\%s]", result, charByte)
		end
	end

	return result
end

return getBytes
