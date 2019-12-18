function interpTime(text)
	text = type(text) == "string" and text
	or type(text) == "number" and tostring(text)

	assert(text, "Text must be a number or string!")

	local totalTime = 0

	for formula in text:gmatch(config.patterns.time.base) do
		local num, key = formula:match(config.patterns.time.capture)

		if key then
			for timeKey, timeNum in next, timeUnit do
				if timeKey:sub(1, #key) == key then
					totalTime = totalTime + num * timeNum
					break
				end
			end
		end
	end

	if totalTime <= 0 then
		local match = text:match("%d+")

		if match then
			totalTime = (totalTime + (tonumber(match))) * timeUnit.hour
		else
			totalTime = 60 * 60
		end
	end

	return totalTime
end

return interpTime
