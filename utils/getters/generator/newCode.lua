function newSerial()
	return string.gsub("xxxxxyxxxxxyxxxxxyxxxxxyxxxxx", "[xy]", function(char)
		return string.format("%x", char == "x" and math.random(0, 7) or math.random(8, 9))
	end)
end

return newSerial
