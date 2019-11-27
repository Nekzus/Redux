randomSeed(os.time())

local function codeSequence(template)
	return gsub('xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx', '[xy]', function (c)
		local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
		return format('%x', v)
	end)
end

function newGuid()
	return codeSequence("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx")
end

function newSerial()
	return codeSequence("xxxxy-xxxyx-xxyxx-xyxxx-yxxxx")
end

function newCode()
	return codeSequence("xxxxxyxxxxxyxxxxxyxxxxxyxxxxx")
end

return newGuid
