randomSeed(os.time())

function newGuid()
	return gsub('xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx', '[xy]', function (c)
		local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
		return format('%x', v)
	end)
end

function newSerial()
	return gsub("xxxxy-xxxyx-xxyxx-xyxxx-yxxxx", '[xy]', function(c)
		return format("%x", (c == "x" and random(0, 0xf)) or random(8, 0xb))
	end)
end

return newGuid
