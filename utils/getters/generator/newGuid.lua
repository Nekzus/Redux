function newGuid()
	return string.gsub("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", "[xy]", function(char)
		return string.format("%x", char == "x" and math.random(0, 0xf) or math.random(8, 0xb))
	end)
end

return newGuid
