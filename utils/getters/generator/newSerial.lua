function newSerial()
	return string.gsub("xxxxy-xxxyx-xxyxx-xyxxx-yxxxx", "[xy]", function(char)
		return string.format("%x", char == "x" and math.random(0, 0xf) or math.random(8, 0xb))
	end)
end

return newSerial
