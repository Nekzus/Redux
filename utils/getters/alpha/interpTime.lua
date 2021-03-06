local orderedTime = {}

for timeKey, timeNum in next, timeUnit do
	table.insert(orderedTime, {
		prefix = timeKey,
		value = timeNum,
	})
end

table.sort(orderedTime, function(a, b)
	return a.value < b.value
end)

function interpTime(text)
	text = type(text) == "string" and text
	or type(text) == "number" and tostring(text)

	assert(text, "Text must be a number or string!")

	local totalTime = 0

	for formula in text:gmatch(config.patterns.time.base) do
		local num, key = formula:match(config.patterns.time.capture)

		if key then
			for _, item in next, orderedTime do
				if item.prefix:sub(1, #key) == key then
					totalTime = totalTime + num * item.value
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
